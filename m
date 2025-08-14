Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434E4CA0EE0
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 03:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF209000E8; Wed, 13 Aug 2025 23:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886F1900088; Wed, 13 Aug 2025 23:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C9E9000E8; Wed, 13 Aug 2025 23:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66D8E900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:21:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7ADA711778F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:21:21 +0000 (UTC)
X-FDA: 83773912362.20.9A4D806
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id BE86240002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:21:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0GaKV7ij;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755141679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TkwBfEL3MguPOmjZZO4CvBPnrISk/NX81xz0Y2PO274=;
	b=YxYXfzB/PTjMdTgYjPXtnzOVf01WAka+mf6wVFRJEC28T78Mojp7mHeVq/KuY8b9pDu2fl
	upbrRg1ZBYg6N1nvVRgOgA42x70NSXfHPlfkYwOUgDk/zxOdyTCPcz01M2LqghxpvlS8Xf
	v+WYBDcR2QOP2M4bbSyL4t/IvVpTvR8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755141679; a=rsa-sha256;
	cv=none;
	b=5YjH9wU35dtAYUISXa+yg16o5++KvjHVJC9pfI8KAbfWDtJ6OSKcZi7vAWSUHFl5nwiMIj
	Ma3RkAvWnits0sY3U21eyF+h8N6quijwFZ8XI4GK7WcV+hoyYCiBF7HA1uevPagMVBbYKt
	j4JskSxwy0df1nu+dPYzp/3mjr8ksbY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0GaKV7ij;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-242d3be5bdfso56685ad.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755141678; x=1755746478; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TkwBfEL3MguPOmjZZO4CvBPnrISk/NX81xz0Y2PO274=;
        b=0GaKV7ijtdG4JhNPwk8DhilrbxKMh96CTVKywpyVk5Y349brY4pdS9p0j++g0c8Tnf
         ZBE9Y7qUuvHI2WTWBQk4epO1T5QFukJPB0rJ4Q3LpmRBUgDTJngyosZGm8Aq4654TUd/
         3NhnJPJPtWuLM/Y+T06UeO3HODN+DTZOtsrU3por+fugQHkPaOa+v+R6EWYQa4wG2SMy
         SCAbUmUjxrdiMqh0VCFkjwCBd/LR3BuHwuZtwx9cZzIxy7iE2GpqW055NEWxEq8BBXpx
         JynQAmnS6mDfWZWFZ4bTSjVEEzvJxyxMomVGHf3Is4gxuXXZlihpGW64zTpH8Id7rb7g
         OvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755141678; x=1755746478;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TkwBfEL3MguPOmjZZO4CvBPnrISk/NX81xz0Y2PO274=;
        b=t54wJJ00AUdEtJBGnZUILGQtULdaoDlzRyNXEfsfNQHjZuDVdQrKwhybo4/raD/L39
         pj4Zadhlysvf7dKf57i/gzZtjJ2EZ9guMECCzomHvMRyJh6jnyMAqKjgtRWwWxcYbVn1
         9M0CexhLeX6HXPUrBpQL02l+JPJxB1vDsPQmGHYmSB18ke+nC6iIpBqxt7AyxlJpn5Is
         HDyj7IME6ppxejA2kjaah97mvo4IGcuQBsA1n9V8WISz+FnNEkZ43FW1iDwY9VpgG0cD
         Nb8j2DJSi6QthOLCpqYXgPNUN9zd2GuBoonVjmLb6bCF6uj0iavUez9gb6zqZ1RD6aD+
         xVcg==
X-Gm-Message-State: AOJu0Yzo6DZuon+5LuCzBMdpn+LtQKqEL0P6WmOJfmIpQu+S9xR9TTMb
	N8usX9kYqjzNGp9pSkZAa6d5xGgb3gKFwpEdUjtY4oesmiiJCU13F4yIlnTEucGq5w==
X-Gm-Gg: ASbGncuPlKwIiTELPgCfgw4vEueO8FAmf8UL7sJ9+hFrFa1T+g3Y3d1uueakHuTXOqt
	XJsMmZyhN4l69c2IyulL7wVyfFBq+d6uF66iJameL/dYcCz4Qf194jweZj43olHof5G6FxxJpqX
	MXnW0oF7KLAEetGET0WZWu71zflpvmOOqwhZJ9QYZl7+OglnGCnhuTlxkyRTmJtsCuwYMUBK8Qt
	QtyhGqlHa9LqF9P0gxpCV/9r9SP+vK4zJUI0CwrUZlyxdIkoSzoayzQDAkVzprEhIiOZ0FXN5Mh
	S3tcF5kJP6IGkR9CuhRi6qhel081Kq/nANTjBmhIWkqjdQfDjCqOvD0yvOE0JlCpb6KrbxdW4mV
	FzcoyzsWbya6nx1SWS3XpIPQhdiPi+98w98EE+/RDVx6T5JnzQoXAOnzoaamUmAtv0UnCbZc2Lb
	6iD2dHwmIG5QH2F1VMocMvrlg=
X-Google-Smtp-Source: AGHT+IGiKC2jvLQMgCUS6N1PH8ivF+wcGax+UkHkV93uf5bR/c7mWi1gGDHe7PwBifyEpZ3AXUO3og==
X-Received: by 2002:a17:902:f551:b0:240:2939:361c with SMTP id d9443c01a7336-24458a1c871mr2304675ad.4.1755141677972;
        Wed, 13 Aug 2025 20:21:17 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:c135:e5b9:9c5b:b898] ([2a00:79e0:2eb0:8:c135:e5b9:9c5b:b898])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422b7d9e30sm28274267a12.25.2025.08.13.20.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 20:21:17 -0700 (PDT)
Date: Wed, 13 Aug 2025 20:21:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from July 31, 2025
Message-ID: <4cd856e8-aed9-5b05-b1bc-5bb7433c12db@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="279713360-1071271869-1755141677=:3995523"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE86240002
X-Stat-Signature: dwzk4rej86bygbeqo7fd8z9ehimx1ujp
X-HE-Tag: 1755141679-667543
X-HE-Meta: U2FsdGVkX19siMRqbqrdpxBoCxZGlzwb+MDssEMwrHLoBOpQbZnF0M/Vs8YbSZcLK2kXWVG600iHqIkbxMm3Hkcb8Jvz3uBvDST8F7HRGtt6WJge/uXOWaBnMz11f4wrrTowSvM9svK4EHcw4fa81Gj/U0VWFS2i+lkG4rT7iVBEEuBXYpJCMf4QRF+C9HJfc4MrKEBg4sxGTtA1X+/bnk+rKLWx6XFqmKNx7CS9sjIQadmIUTRkbfqHvuCxRorzBW86HJHTH4iDEhq+XdWTubp7bLVUqL7OirsqzlNVxlaSVF8JsnrYjy+CqcJrenQcqGW6++SRTsX5n8YZ7WnBWPdrohtp0cBALXGglKR2Lcro/usfl5IFt3VuAl73ROxtbqFWlIHub0gzObtuyopwDdrR07Qw9zvfmGGR9F6FdwSRD+3dTPxKDiHteQy5UCL682xXdAD3rarrTnFLSVvM1eJ1Z5gknzp1u1673xViOh+9XEjGFsrdW1+Ox2ufTiP8DhEiugM0TczZ8OFBsyiL9/NHL4Q69yRcR9xpqPOBH2hugr+BxTYmsSuJQimPhwY1IN8hvk6wS0t99/cbwwN4csNrRT3mb3254e03VQ9bodgpqXp0AePDI2X3WStEUbQe5ueaNUG9KhUxs1PKDJ2W1o9X7BMJzgJiQzR6VnXzYc05ha9Q9AQjkSeDSWXA3ExbolR23Y748Z6nBpPc3cN8H+NcML6C/0N6fOwINQxlNAj9KqU8ae/J1lLA4sH6djkfBAC4x/Dq8wOJZr7KJC3tOUoxEALo47JmJZtwUELyyUP3C/+Wt7ArxwarZwtjExIZ8BbFxZFH1RrcWoEFk+9Oo3TIgQMoHZuLykLZDea3plGyDjr4WE272k/Fc4RGFMj6duZ6l9NiWS/QrQ5SLWPT7/7Eghv3102ylKwW59o5Dn9jpf3XQAWANnaOVcrnEsAW5Mk/Gc7b2n+aL79TyzY
 8VoocYMb
 nZcr2Uv61mwqylh00YNqMTAyMt/6l3MjEi7kJmRYOyXcin9inSBSDwA5rgP4XwDhtVWfYMcSXUZNehr3q0EqzKkunpW8qwehr3/hWWBmwLYiGcjRvt3qkTMtE+wgFfS9Hj83AhSqNMwZU46014ZK+K6UBc2T3vylt75LPfBpoebI45gxu0ZgB0dmfh4OGUgQSiX3vNTvCJpszGI3TG5CDfRF7NL7k/n2Me338f1h1GZiKwl4fQJmauBuuqAvH+g5IwhNYz3PMDGju2BigsEvxS0Pxjr+EEy2oRVJ8qc2hLm+al0NnA9nnfmQe8UCbsUHr+FM91ng1ICwC/sZAUCiJv041ke4B5+KrAwEAJWa1JRKb89DUpHd2yk569xWlsGhRDEtGQh1MlbMK2EMUqCNhlyR/solj6Vd6CWimNvwSVep5k9ptIzM28V+BJ/CTA3S/V1tMYH4GcFmzNL4my7uYOHRX9AFCBzXPyiDGQPFw9OPM/+fJ09FQ5H+zD6XHy/6piTjUJ/uYeMrUBsl7OK/w4SycSoo0FpDE2fhheqnwG1I112WECzFdd3PMJzBrE+n3NA3SfINgRbx2T48SojND/di7OctkdYG5b0ReSMFNTRF35Ds=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279713360-1071271869-1755141677=:3995523
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, July 31.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Jonathan Cameron started off by talking about the LPC microconference: see
https://lpc.events/event/19/contributions/2009/ for all the details on
that conference since there are some overlapping topics with this call.

----->o-----
Raghavendra updated in chat: ”Status: Coming with RFC V3 with many of the
TODOs addressed  There was one BUG that was causing idle system to crash
got fixed (wrong kmemcache) there was a corner case where in MAP_POPULATE
where all the pages were getting migrated, fixed that, but code is not
looking great... will experiment a bit, cleanup and send it very soon
(early next week if not by this week).”””

----->o-----
Bharata discussed early integration of PTE Accessed bit scanning and
kpromoted.  He presented a slide that I added to the shared drive and went
over kpromoted as the single source of page hotness truth.  This like AMD
IBS, kscand, LRU, CHMU, etc, can record access and store in kpromoted as
the single source of truth.  There was some confusion that was clarified
that kpromoted was not actually a kthread.  The list of hot pages can then
be sent to kmigrated to handle hot page migration/promotion with an
optional use of hardware acceleration if available.  PTE Accessed bit
scanning is now referred to as kscand.

The single source of truth maintains page hotness information only for
memory that has been accessed, not for the entire system; this was to
address issues where it took too long to discover hot pages with regular
scanning.  The single source of truth determines which pages to promote
as the final decision maker.

Bharata showed an early benchmark, abench, that does random memory access.
kpromoted+kscand was roughly on par with NUMAB=2 and very significantly
better than NUMAB=0.  The number of pages migrated was also almost
identical between kpromoted+kscand and NUMAB=2.

----->o-----
The page hotness data structure ("kpromoted") supported a has table for
quick lookup and eliminates duplicates.  Hotness of the record is updated
when the access is recorded and records that cross the hotness threshold
are pushed to Max Heap for easy retrieval.  Kmigrated then extracts the N
hottest records and tries to promote that memory.

Allocation and deallocation of millions of records can be an issue.
Accesses get reported from atomic contexts and the statically available
per-page space for storing hotness record is preferrable.

We discussed statically allocated data structures to avoid constant
allocation and deallocation of the data structure.  I asked how many bits
were required for this, Bharata suggested 64 bits.  Previously, this was
done with page_ext.  Gregory Price noted the static allocation of this
may be contentious upstream.

Wei Xu said time may be optional if we can reset.  He pointed at three
data structures: hash table that stores all information, Max Heap for the
hottest pages, and the migration list.  Bharata said the Max Heap would
not be as big as the hash table because of the hotness threshold.  Max
Heap can only store a certain number of elements.

Bharata noted that pages move from the hash table to the Max Heap at the
time of access, not during a scan, when the hotness threshold is reached.
If we exceed the capacity of the Max Heap, then we'd need to rediscover
the page on a later iteration.

Gregory also noted that we could discover page cache this way which was
not possible to do with traditional NUMAB=2.

----->o-----
I followed up with the group in email to keep the conversation going
before the next biweekly meeting.  Bharata there noted that the source of
truth only maintains page hotness information for lower tier memory.  It
would be possible to extend this for multiple lower tier nodes if needed.

He was also planning on exploring reusing or moving the existing
throttling mechanisms from NUMAB=2 to kpromoted.

I asked a few more questions as well:

 - any thoughts on memcg controls that this could use if we want to
   control the demotion of memory for latency sensitive vs latency
   tolerant workloads?

 - klruscand was mentioned; trying to figure out an update for that and
   any potential next steps

 - Wei, could you update on sharing of internal code so that we're all
   operating from the same base understanding and surfacing the overlaps
   and opportunity for collaboration?

----->o-----
Next meeting will be on Thursday, August 14 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on status of kpromoted as single source of truth and the
   kmigrated kernel thread
 - determining if klruscand will provide yet another source of page
   hotness information based on MGLRU data
 - update on sharing Google approach for both to overlap the shared goals
   and converge where possible
 - discuss proactive demotion interface as an extension to memory.reclaim
   + possibly leveraging working set extensions on top of MGLRU
 - discuss overall testing and benchmarking methodology for various
   approaches as we go along
   + minimal viable infrastructure, testing workloads, and metrics of
     interest to collect
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace

Please let me know if you'd like to propose additional topics for
discussion, thank you!
--279713360-1071271869-1755141677=:3995523--

