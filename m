Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E84C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B686B008A; Tue, 28 Jul 2026 01:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E217F6B008C; Tue, 28 Jul 2026 01:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10C96B0093; Tue, 28 Jul 2026 01:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 852C06B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:25:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1BAF1C02AF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:25:48 +0000 (UTC)
X-FDA: 85037048376.12.7F2D033
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1DE3340009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:25:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RFbfxAiF;
	spf=pass (imf04.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBznR6Jhz6jAQdgNETeOJVk7gwSsazLfaU1tbs21Zf0=;
	b=XD2sbmBDDfrtg2VyKtEMnXEiWmxm7mVTgDiqQ77f0QKuSSOcNXkZaaipE7Ea752qD8DC1K
	50xYEKKc3Gvy4wkmwgXrr/ZZZ+zLslBNXvYN5gcSZw+N/2qn5HFxtFSKi2eupeR9wLTH3x
	UZFZ8jp3gfZXQvxIK4c49dAbeCr7JOA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216347;
	b=a5pxo2ti5OqyNULZ/3x/3mcxakZ71R9ZvPme18CHpYa+Xx2VFfhImHM47I0F5ngRo/lh5F
	bO99z8f1C93uh7kc3sowAmSCBniA0TRxCSSMwsv8SYkFzoJgzVv6s5RkGYdnzlPUbFopW6
	2WjHNxwmzqE0XBiBrecWsSMfwciaMU4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RFbfxAiF;
	spf=pass (imf04.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5218927884fso36819181cf.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785216346; x=1785821146; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rBznR6Jhz6jAQdgNETeOJVk7gwSsazLfaU1tbs21Zf0=;
        b=RFbfxAiFJ0a6tRKFk85gkCspdhishb6SkpTGeTbYs4NDWix3ixUuaIMKS+7nnW5zSp
         vYF4yIlaxj16wFwGVzxsmwwgOo62+XaEpRgUb2BUCSxK36h6NY2sI8B78W3qz86fc30O
         qrdKlLBqjEfQvlnVUvjTviqfjzyhv43Ct3ZGAMRFnRjLz9q6FqPnJpyTzHdQxjkqSu+U
         SSyUA0PA74cYK3SR6sYxQ0F3N50l4mX8OlCCPdSrj/0S7bBnf/fPiKNiUFDRUstvaEor
         WQljig6druKiPj9sg4lGHbpbWZNkQM03PACLHz4n6ewVm8ocpJHhEzYf8bEpc/fTCei+
         a1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785216346; x=1785821146;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rBznR6Jhz6jAQdgNETeOJVk7gwSsazLfaU1tbs21Zf0=;
        b=qEosvmyOCluNnAeqHzCpymZnB8OYVtHdJIgcMXPJi8IaH6JmE3a5yAW6LB4Fbc0gNQ
         PbZYBym19Edk2pquLYTZABHTXZDXT1V08GJULEIrdoVamfGQshVrAKdnY6oJ+c01jRZh
         Bz2369+ArESF6ZRbZUzO5qKV64LcS0ODBiyKuqXy0ic0iw/xJVT/NNk+DRpYM0aQUYH+
         3Jm+hlwQqV/+w0sbSCOuYqcXq7fZosTFfagiuGXi5L0TTcuUI7Q/ToVQl/JdQBvXds9/
         /yQeWB7/Wmyz9ck44q/Un4XzLsJ3yfMrP2RZ7QOjpRkRjGgmDvVgd5XXfiL6XudSQX56
         ngaQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqwz/OXKtd3HSd8/W0w20Zcj/9O+UgRXX/0yCzwDdwcu+FaVepsdm6Kw7TbGKRjIZ5VgdLNXvXMEg==@kvack.org
X-Gm-Message-State: AOJu0YybTHP1luYcc0J34P4iZugujUBcF/S3qcLGN77L+hyC4qmyuxhB
	SvDk6jIau9rJa08Pb/bpqe+TV6kkagUFAv6KVoc9mASnMwN7kiIXmWFt
X-Gm-Gg: AR+sD12nZEe5iF6m7itRzMWWnx1/H8A04GN/U7rCIkVjnWjwIvVWzVExq0e4eY0j42+
	m+XXKHK2zjs7DI/gMVEDqXoGV/HgnB5z5OViAHQhjtIXEDIUGwjPM8tYyey7OVJe5LvK6CjtYV2
	EKrNuNMfiy5vlIasXVzSXALl5aPOOjnbVfBenz95cnPS7RD7+ip8g3t6fKuvNpElKi3PmvNPwLS
	IMFb42LXSddC+grmmzk9B9binxD7fNtzsgG2ISn2IByFiU9vMFrqfFRCAmkUkw49p5E/WILA15N
	8rIPwP+6Y6Iqf0qs7OymXnthAIhwmzMIKa2/FIoh/BF6j6hv42U3jRdsm7Ylqu6mxQ/Yu6PnM30
	vTL7IHTxFR1DDM6LOk+5jKW1Qtgt0vE2NrYrH2kBL3TD2tj0yGQ2jyscOEQFdrxXY8TAxofmKcE
	tQdDVPCJyi8aukA4KihwuI3ZTfSt0gTZwh9wYRXU0EfihLY/NeLvARXsLtirgzeovLjhE+vFFY7
	T5X9A==
X-Received: by 2002:a05:622a:1b0f:b0:517:6b57:8164 with SMTP id d75a77b69052e-529d70eabf0mr6863181cf.55.1785216346205;
        Mon, 27 Jul 2026 22:25:46 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a298988fsm66434241cf.18.2026.07.27.22.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 22:25:45 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: fmayle@google.com
Cc: jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	kaleshsingh@google.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lkp@intel.com,
	oe-lkp@lists.linux.dev,
	oliver.sang@intel.com,
	surenb@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5: pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Date: Tue, 28 Jul 2026 13:25:26 +0800
Message-Id: <20260728052526.3743086-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAHCxdc64d-6qNBwwSZX8mdz4-V+88No2x0wG4mex5WPXBDE9AA@mail.gmail.com>
References: <CAHCxdc64d-6qNBwwSZX8mdz4-V+88No2x0wG4mex5WPXBDE9AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1DE3340009
X-Stat-Signature: k1cn6i7hcf7oi9fuufefhpwtwrfsz1nh
X-Rspam-User: 
X-HE-Tag: 1785216346-763839
X-HE-Meta: U2FsdGVkX1+GQlMsTJQF90koc4OHlkUL9dcq0Ex4TnRHCPRwes7688IpObkTAdn+G2xfVj24MU0GiHzQR5epu6zvrPpKvFbdsqTZmW6B+9W6VqNx5h/W++vH/u9XE0lB9jMi9cDL7n2OBiYrA6yBBqiCdNiTO93Mh+JZf+/fTy8Cjb0YfjMwdeuRGfJLn+zxCB1+j4WvYmR1dz3wgdYjBwehKfKjgrsthtOki196o19MlWG4vrDOfVB0eyYtNbfOpd9L2tMAbrKdfhUarxna0cu6hohaN+JuxEpTsrX/uByW5xr/2f6CQXlfbDQqe0wBWvyEwKt5rAlgjyeTeZYHIN7FG+uXbZ7IbD66kUIjia9dIRuHHep21a9Vn7vhCE6YkIC7RjdEyAllZHDefmGwWRw/bd7mIuDTDoyyxqpyxplN4dDePwLlZDC5W8eAxSBw/msEWIasOINmGurMjWgIF9NV/FKP1A9g9OG9xiDA7PZV6zqCPdfx0zCRwUqArg73q02te/+XPo5N+nrP+DP1VfUmDuC/tS7dJqqIlrl2CRrfxhzElD6QqN/Er/Z7tbFErF1RrvLCA401jlGrlMleQXy4WFf3e7J+HTyVtMprkItt59/77TlgbeuZRpbWqejX0Wk47ff52o+3B5scAl17g+gzaGbRfuBgNVVFIjBhZzSemMn1cWBYnbbC8WTrfWV1w7uwrXKdJthmEPmuCoOW2A2igxZhGjh6fvKW01oppotCj+Uihh1SZjlez1484QN4qD+flizJKiYyWbRUWLlew7R+KBjuhl+6sSRTGw4C8HYDGPfdzl6+janlIOjq5kSO1YVoY9qqf/BEDf75VhpcUROca1GDAxDRm+Qfk0+bRds/yYsah1pEwmoUMRoq5AmN5Dl8wLgrhyy3XCM3QJ5tDgqGW+DYGRol4b4sp8wMulofEMQsQjTxIu/y1DqiMQNQaEcHGyoMDa0Q0xAXvLX
 p3LA8TVP
 gsiH+Ry3gyRC+ikOPAiVshJ4lP+j6em78L+jQo42I8LueM91la7PAJhYR+/ZFyaBg8uSBMvKV6EpDmaxB75XT376jUxNx34NyWyEBeC/OATwC3m/Jg8kGjFAwuIdx5Deq0xguv3ErO0FAw+3EnSEsZ80GNSHJ6bRPFpMOpCKhQIgffV18Z99CRAX33jxRgUmFu5rMyYuOpyY22X17xI6UOQ+jdXHL9yuqaHT/xAyEfVPn4J564fUk0DzS60gHhJ1oID87/5ftq87uDie5iqhTE8fPQzsj71nnv/JQukjFXHHQZ+fJJ0+j73XfBpPXTyOSTCe3ERluN99AbPMBwVnzbgdOs4I/2J+koo7mkWz6pEXGToavInRqUX07kTXLQg4ZNvi6wgAVSYMCyOKShiWy577rNqx9X/jb0pkVYkkI7Q4B4puznNxrxv4suA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 01:34:38PM -0700, Frederick Mayle wrote:
> I maybe missing something subtle, but, I think you've changed it from "don't
> read beyond the VMA" to "if there is a chance we could read beyond the VMA,
> don't read beyond the VMA", which seems like a more complex expression of the
> same behavior.

Hi Frederick,

I looked into the SVT-AV1 benchmark that triggered this regression and
found why unconditional _max_index causes the 870% major fault increase.

SVT-AV1 uses per-frame mmap on Linux to read its input video file.
From Source/App/EncApp/EbAppProcessCmd.c:

  void read_input_frames(EbConfig *config, ...) {
      if (config->mmap.enable) {
          int64_t offset = get_mmap_offset(config, read_size);
          input_ptr->luma = svt_mmap(&config->mmap, offset, luma_read_size);
          offset += luma_read_size;
          input_ptr->cb = svt_mmap(&config->mmap, offset, chroma_read_size);
          offset += chroma_read_size;
          input_ptr->cr = svt_mmap(&config->mmap, offset, chroma_read_size);
      }
      ...
      svt_av1_enc_send_picture(component_handle, header_ptr);
      if (config->mmap.enable)
          release_memory_mapped_file(config, is_16bit, header_ptr);  /* munmap */
  }

Where svt_mmap() is:

  void *svt_mmap(MemMapFile *h, int64_t offset, int64_t size) {
      uint8_t *base = mmap(NULL, size, PROT_READ, MAP_PRIVATE, h->fd, offset);
      return base + align;
  }

So for Bosphorus 4K (3840x2160 YUV420 8bit), each frame creates 3
separate mmap regions on the SAME file, the layout is:

  Frame N:   [luma 8MB][cb 2MB][cr 2MB]  (file offsets contiguous)
  Frame N+1: [luma 8MB][cb 2MB][cr 2MB]  (immediately follows)

In page counts (ra_pages=32 assumed):
  luma VMA:   ~2025 pages
  chroma VMA: ~506 pages each

These become 3 independent VMAs per frame, but all map contiguous
regions of the same file. The encoder accesses each sequentially,
then munmaps before processing the next frame.

Here is the problem with unconditional _max_index:

  1. Encoder accesses luma VMA sequentially, readahead ramps up.
     Last async readahead window: ra->start=1993, ra->size=32.

  2. Fault at page ~1993 hits PG_readahead, triggers async readahead:
       ra->start += ra->size;  Then ra->start = 2025

  3. In page_cache_ra_order():
       limit = min(file_end, _max_index); so limit = 2024
       while (index <= limit) ...  so 2025 > 2024, reads NOTHING

  4. Pages 2025+ (which are the cb plane data) are never prefetched.
     When encoder accesses the cb mmap, it takes a major fault.

  5. Same thing happens at cb->cr boundary, and at frame N->N+1.
     Result: 3 major faults per frame × 120 frames = hundreds of
     extra major faults, explaining the 870% increase.

Without _max_index (original kernel):
  At step 2, readahead proceeds past page 2025, prefetching the cb
  data into page cache. When the cb mmap is created and accessed,
  the pages are already cached, so minor fault happens only.

With my conditional patch:
  At step 2, vmf->pgoff=1993, vma_pages_left = 2025-1993 = 32.
  The condition "32 < 32" is false, so _max_index stays ULONG_MAX.
  Readahead proceeds normally, prefetching cb data.

  Only when vma_pages_left < ra_pages (for example, the last few pages
  of the VMA), we will set the limit, at that point the readahead window
  has already pushed useful data into the page cache.

For workloads that mmap sequential regions of the same file (SVT-AV1
frames, ELF segment loading, mprotect-split VMAs), the data beyond the
VMA boundary is useful and will be accessed soon via a different mapping.
Blocking readahead at the VMA boundary in these cases hurts performance.

The conditional check preserves the benefit of VMA-bounded readahead
(avoiding useless prefetch for small partial mappings) while allowing
cross-VMA prefetch when the access is clearly sequential and far from
the VMA end.

Thanks to Oliver for reporting this regression and providing the test
case details, looking into the actual SVT-AV1 code made the mechanism
much clearer.

Bo

