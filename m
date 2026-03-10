Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 286E6EFCD9F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA646B0088; Tue, 10 Mar 2026 05:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B2B6B0089; Tue, 10 Mar 2026 05:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DE66B008A; Tue, 10 Mar 2026 05:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 57BAC6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:13:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04BB71B6D63
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:13:04 +0000 (UTC)
X-FDA: 84529589130.16.536FC44
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id BBD6D140008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:13:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lL5e644D;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773133982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8F2bhMtMSjj2oDQi+clrIi22Hq+QZEwsyB8SqkUi+EM=;
	b=Gwn1p0TYyM2ENTpxGNgPYr6QO5jVHZc7tM+cvZIE9W08VA3e2qtsiezQQB+iNZQLKkUjv4
	AEGiKgSUsJWlaGBGshU6FZYNyQAO333F7NcqsXz0jA9VrPKcN0ecnniZyo2YdF4rmBx7al
	rG2eLNiROhubkELbhN0J8r+IXMOI/9k=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lL5e644D;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773133982; a=rsa-sha256;
	cv=pass;
	b=xgxbpN1llmKF1e91rnGb+Po4/PPZtX1+fCr35gGviWjZQdk+7wQB8xyWOgasNzPKMzof3g
	MH3i3b7wPk3BmbHpcV1l5nGciRGgnDq0mg6efgykV5D9wh/tZotgqpG7rQYaAjAgyZoC2V
	BFeJNKKsOa3eCj7W9m/7e0aDF5Qutjw=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a126b79512so5205942e87.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:13:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773133981; cv=none;
        d=google.com; s=arc-20240605;
        b=cU2JdL/UYz8bHQiNEb39QZQowTAhd6NRrF6fsYbkok028VDPOsagQ1txDj7gTarZkh
         3i8E0orpsVFr+hiiLyef62bFjE2JoHDGI7vzDXcJekXFV2iu0/jyBczxpcTfw0JdW9By
         axxeSLt30ENREcumTHTMYRRmSf3bpRQlbtnutiFlcGAZOBdvzGKiilPhMMAv8jIp+xCZ
         5h1PxvsfBhYS7BtWyw4BTPyzowJTpZvnM/shajzw+sVqBBJupF3hd75bzvp77Ol5tvtW
         qEeYXfJPIXKYsBaQ4UnC0H3tKcPYlezFiC4sWVWADq15zV/0TZ89ADAMdLKr9QyC3+u8
         NEdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=8F2bhMtMSjj2oDQi+clrIi22Hq+QZEwsyB8SqkUi+EM=;
        fh=dmw/L0g4XHbiduIf3cXAEISfvnNRNq819rM1FVGI6mY=;
        b=Gt2WVxGhAqvF22lCc2h/f7ZkBWGzr1Z6wcVkqVLUtHzHCdzXoN/3/AUbgWtj68EMos
         ycQsI8y4e6fpbc2M/uIIfcqiLSlp7SAKq5jQfHCZ5xa+Fr50+V5pHqGpJluxvk+gcoL5
         vd7GIG109ipNbZY9JUfzXwGoEu71HcnFt6VbYNAG6G5srKLMCUam0TTt/1N3r/nj6a53
         Hq+ETw61EhORL70xjSgoQ4V7aI4N9PTpPSZ1NxKvfVz3mwDPogDvfebqR97KLeeb2b1Q
         m0aXyNlluX9zcJJ6bdl4lsWXQtKb5YvzvLho9OHI+YCKMPPqAopoM2Xh6A4EDQIBP/0G
         ZxkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773133981; x=1773738781; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8F2bhMtMSjj2oDQi+clrIi22Hq+QZEwsyB8SqkUi+EM=;
        b=lL5e644DmmZndweuLEoOhyOwicI5ZO8c/U7cKUpo8/aLMk3LlF4XX1kG0uTjz+c4Cu
         Uvv1TGH3BhKTKzLIJUCpZn4b33bDGw2G+ALNpaRmKKG0jg9O/aI/Me+kPLGeiekxt1E4
         U3fAADcmZfuQCzSr+CupX3azAyIe2Kf5Pa5ksp68pOxwJm7f2sDx6wUl+i0MBBCKVtlF
         1Wsw+9WEYWoExX55VUrvfa5cmb6yQUjPaLyWLku8WZFA6sbExb2dVWH9Kss05HMlg28d
         CC6SuRLqVzKo3z3eJksHrQ8BpVBYynR59m/19NnlxgGY0nk+nYH3+3P6ttS8NcbN9S+L
         KUXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773133981; x=1773738781;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8F2bhMtMSjj2oDQi+clrIi22Hq+QZEwsyB8SqkUi+EM=;
        b=Tz/UQR7D/37ObSfDqJFwVqwQQh7iT4Fl80dDvp80l8rzIzT5J9p7GTfi1mYh2/MOZz
         KPhdA4kFQUb0TEcoIOzlQ1xKYQJuF5p9e976+fyCpwvhEUC/v+Z4suMPu2P4lQZlW7tS
         mue4lcDdCq1yKpz1U6bhIsv5xV6zDYMzV+OK57mqJfTZCmBb8ZxkpswYHPG4yEvIHy+I
         GraoyuSACgxbPhJZhysEKw+Lsl63x7JIEK1eyjakP2Fgl+BJvoZDV7jSeVs9zLduzXIM
         lYd3JE/TeVxvSg3fKD4mzVyB8KgCpdfsRkCLmg0DhhjAUIq/2M7zhd+pX9/BeCYa1cG4
         BWOA==
X-Forwarded-Encrypted: i=1; AJvYcCVAWhHmNaS1NdugKe5dQpBb5KG1WUxDqn3DxPTR99HWQLsZwwoU93epOCfmeAvK3+HkbbKxP0Dktg==@kvack.org
X-Gm-Message-State: AOJu0YxaOq/T2td4mxIskU9+fppwqPaEIWfFoz2xStpB0mos67BI67gO
	UTkcO7eZwO4IDfMOgR7oRdYAn073zAmB4+/v72hgZg1kdjKg+LbmBihxE2AQDm26OLekN7fwMwN
	+6mWezOQ2YYK5lBsz30T5aJrvNO2+Wplhl1GnJUsp
X-Gm-Gg: ATEYQzzl/1UP3iXhmlKxf9NhnuO9t8qNiWqa6F53LP4jmXdlVxk+N4W3OlcQkVKKRZV
	TsTAd5jFgDFbf88tTm68mtlhc+Tw4jvxH9GlLSQG89MEPBfvGAP73PMxBbEY81LTJmT91/Vk57K
	/gu6x/AsAEpwjLhGZVgpYehP2IIxMJvVxGGw4iQNxU35IlZRLSsDZodGrZ6yJoGqbahD2puTeD2
	E6YRJ7no1hli9F5b4g4MVtCa1JwVhcQ+Mj1pVIqtliSIrgLkIgGXXf042FrX1kaA2hr+msUZU3s
	MpaauERXVKooh+PmXzETHHjUqLiar3+zPwwBOwNdFMLEi2Bg6hwqjTRI5C/pcs/q+RWRzQ==
X-Received: by 2002:a05:6512:15a0:b0:5a1:3d7f:8f99 with SMTP id
 2adb3069b0e04-5a13d7f92a6mr4647476e87.33.1773133980196; Tue, 10 Mar 2026
 02:13:00 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 10 Mar 2026 02:12:56 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 10 Mar 2026 02:12:55 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aa9uiQ_KBcX7X0My@google.com>
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
 <20260309-gmem-st-blocks-v3-2-815f03d9653e@google.com> <aa9uiQ_KBcX7X0My@google.com>
MIME-Version: 1.0
Date: Tue, 10 Mar 2026 02:12:55 -0700
X-Gm-Features: AaiRm51A8Xbcuhtm9ZZHMK7hG6LdHLXwjTxvFIPiUIWCbO2N0i2NdJbEHgq4azA
Message-ID: <CAEvNRgH1RAV0rcaUx717JcHryB6=teXYoGtEzZwGwmy3MWwOcw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 2/4] KVM: guest_memfd: Set release always on
 guest_memfd mappings
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	rientjes@google.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	Lisa Wang <wyihan@google.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BBD6D140008
X-Stat-Signature: 59ztttxxawbobrr1cb156zdwe9jhydy6
X-Rspam-User: 
X-HE-Tag: 1773133982-39785
X-HE-Meta: U2FsdGVkX1+28/KhDXSKxnNTeiw7qqEjFWzNlTNkxP3tHBU0k5lSHq80hsbGAOSqhGYJpTaBwj+Q8hh48NQTlGS3LKeaHibkK8keb0hM3tuxxxF4Tg1m6CzSizVUu8DDcqgfpnt3N4w5JQtpTF8thWiYNTFKWZYkMzr7c25T7aZ+4DGxkOx0Xf8p4iHZdfuYIqYbHhG+D36nxZ3Oh/bveVJ28ZJyzeH0KQL3es2TQoB7wZuveMAf7ebNOnU5ClDXiHbTpgC60GwB0ZWPYxPbNJv8bdeNNWIc4lZ88rTR6czJVI6kcevPDq1PWp4YFafYKxt3eu3SvzjARZvHWI+dESjU5OtzWSpfZKRuNteUkSTERH59YLMALVC2ZyKFnjgbOomcVItieb17BsI8xO5aHSxQMnaQyHOaASnP9d4EMezMo0d1ioqQ+Y9X5u9m8IYy/9J1b9vsWIcZFlUYPMERoI+mHz2I1jSVK2IuT6ybV36NaMjcfWTf+Gftj5+11b7WFfGrBrOb6KOeutkeNoYTi2a3sa+m7c9qAT7xVgfegre2U7wz+s2kvCHt1Dm9tsvVrfmjqv8rRNhdCIOjwDP70qkmCPC37D5R/ombwCY6rpekpaS6fTpujm8HXTt+YJbIL+uMRb4iTsqvouQDyxjqbmQ3gfl6B/Q8tJXsNQrUXV493DqMkZXQNOhhc/ga0lVMDiRskp1WwYeQdSNDICoJTPk280yjlT1fFKJTvaZ/qpk8nh5pL1AGv3buzcCgRZDG7o93Y7KqO/sndR2H0t9pTgR4KC+9HI84ZGu+Ae4/t/H342oDuHQl0Ig43dSfCigdERHWudShClyXw6UOFx21RiS7LJUSFbSEQTr/lY98guGzmuZeuuwmBlfvXFCMMU4ygBQ+aqNSwvGc9bqEoCp8ttrulU6oPxKNrhYLNjeze7aK0U/FKW9B6me1crOsCSfXLDKC7uUfCjC9m6N92Tp
 VnhVnBe1
 TdygeC50P0SwaWxvs1xeUfqDKYaz3buQbN9Jn9P7kO76hKeldvZFzo1Bway90tQHYePBx43gwj6BdWTfTe0rQpbgLsZD89xaVqpZ0p+61Ry4THEEtKydVG/O+krX2IQH/+SFH36tuY6beuSPKr/vam4vR93PqZiw57Dy3YYh+lfi2Img5C3+Ye/8GpxCJI3sPLySTb/p3sE1pqasnasAf5nlVA3o/TTscDx2M9qPqgiMsgJJ2MGYktGs7TJrGdYQSp8RYXk5sHyhoSZEBltShgTt6srX/IssX1gTAVqFkvoWxmEFuwEEgMAVGPf1LYvDMStnYXOpAdXMmH6MmYSYc5aTMUNJ8QwTg4JIEDrklhLk+IbNvNPYbzXcopNY0jcKHt7kML+DW4ci0Pss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Mar 09, 2026, Ackerley Tng wrote:
>> Set release always on guest_memfd mappings to enable the use of
>> .invalidate_folio, which performs inode accounting for guest_memfd.
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  virt/kvm/guest_memfd.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 77219551056a7..8246b9fbcf832 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -607,6 +607,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>  	mapping_set_inaccessible(inode->i_mapping);
>>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>> +	mapping_set_release_always(inode->i_mapping);
>
> *sigh*
>
> So... an internal AI review bot flagged setting AS_RELEASE_ALWAYS as being
> potentially problematic, and I started poking around, mostly because I was
> curious.  I'm pretty sure the exact scenario painted by the bot isn't possible,
> but I do think a similar issue exists in at least truncate_error_folio().  Or at
> least, *should* exist, but doesn't because of a different bug.
>
> On memory error, kvm_gmem_error_folio() will get invoked via this code.  Note
> the "err != 0" check.  kvm_gmem_error_folio() returns MF_DELAYED, which has an
> arbitrary value of '2', and so KVM is always signalling "failure".
>
> 		int err = mapping->a_ops->error_remove_folio(mapping, folio);
>
> 		if (err != 0)
> 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
> 		else if (!filemap_release_folio(folio, GFP_NOIO))
> 			pr_info("%#lx: failed to release buffers\n", pfn);
>
> I _think_ that's bad?  On x86, if I'm following the breadcrubs correctly, we'll
> end up in this code in kill_me_maybe()
>
> 	pr_err("Memory error not recovered");
> 	kill_me_now(cb);
>
> and send what I assume is a relatively useless SIGBUS and likely kill the VM.
>
> 	struct task_struct *p = container_of(ch, struct task_struct, mce_kill_me);
>
> 	p->mce_count = 0;
> 	force_sig(SIGBUS);
>

Glad you agree that's bad :). We reported this earlier and Lisa has been
working on a fix. RFC v1 is here [1].

RFC v2 (Lisa is about to post it) will address David's comments by
aligning shmem to also return MF_DELAYED like guest_memfd, then handling
MF_DELAYED returned from .error_remove_folio() accordingly so that it's
not interpreted as a memory failure handling failure.

[1] https://lore.kernel.org/all/cover.1760551864.git.wyihan@google.com/#r

> But even if that's somehow the "right" behavior, we're doing it purely by
> accident.
>
> As for this patch, if we fix that bug by returning 0, then filemap_release_folio()
> is definitely reachable by at least one flow, so I think guest_memfd also needs
> to implement release_folio()?
>

Is posix_fadvise() the one flow you're talking about?

It indeed calls filemap_release_folio() through mapping_try_invalidate()
-> mapping_evict_folio() -> filemap_release_folio().

From Documentation/filesystems/locking.rst:

  ->release_folio() is called when the MM wants to make a change to the
  folio that would invalidate the filesystem's private data.  For example,
  it may be about to be removed from the address_space or split.  The folio
  is locked and not under writeback.  It may be dirty.  The gfp parameter
  is not usually used for allocation, but rather to indicate what the
  filesystem may do to attempt to free the private data.  The filesystem may
  return false to indicate that the folio's private data cannot be freed.
  If it returns true, it should have already removed the private data from
  the folio.  If a filesystem does not provide a ->release_folio method,
  the pagecache will assume that private data is buffer_heads and call
  try_to_free_buffers().

I could implement .release_folio().

Returning false seems like the easier solution, and is kind of in line
with the documentation above. A guest_memfd folio does not have private
data, so without private data, the private data cannot be freed.

(Took me a while to notice that having private data is not the same
as having something in folio->private, so this doesn't change even after
the direct map removal series lands.)

Returning false is going to break shrink_folio_list(), but that probably
won't affect guest_memfd for now.

Returning false also breaks page_cache_pipe_buf_try_steal(). Does anyone
more familiar with splicing know if that could affect guest_memfd?

Returning true could also work, to indicate that the folio's private
data has been "removed". I'd also have to do inode_sub_bytes() in
.release_folio() then, since in mapping_evict_folio(), remove_mapping()
doesn't call .invalidate_folio().

Then we will have to separately ensure that in truncate_error_folio(),
guest_memfd doesn't double-deduct the folio's size from the inode. This
should be semantically correct though, since IIUC .invalidate_folio() is
when a folio is removed (clean or dirty), but .release_folio() is only
for clean folios. If .error_remove_folio() returns MF_DELAYED, the
truncation didn't happen and so there should be no call to
.release_folio().

>
>
> Full AI bot text:
> --
> Setting the AS_RELEASE_ALWAYS flag causes folio_needs_release() to return
> true. This correctly triggers .invalidate_folio during truncation, but does
> it also unintentionally expose guest_memfd folios to eviction via
> posix_fadvise(POSIX_FADV_DONTNEED)?
>
> If userspace calls posix_fadvise() on a guest_memfd file, the core mm
> calls mapping_evict_folio(). Because folio_needs_release() is true, it
> calls filemap_release_folio().
>
> Since guest_memfd does not implement a .release_folio address space
> operation, filemap_release_folio() falls back to calling
> try_to_free_buffers(). Could this fallback cause a warning?
>
> fs/buffer.c:try_to_free_buffers() {
> 	...
> 	/* Misconfigured folio check */
> 	if (WARN_ON_ONCE(!folio_buffers(folio)))
> 		return true;
> 	...
> }
>
> Because the guest_memfd folio has no private data, folio_buffers()
> is NULL, which will trigger this WARN_ON_ONCE.
>
> Furthermore, try_to_free_buffers() returns true, allowing the folio to be
> removed from the page cache. Because this eviction path bypasses
> truncate_cleanup_folio(), it never calls .invalidate_folio.
>
> Does this mean inode_sub_bytes() is skipped, leaking the inode block
> accounting?
>
> Userspace could potentially trigger the warning and infinitely inflate the
> inode's block count with:
>     struct kvm_create_guest_memfd args = { .size = 4096 };
>     int fd = ioctl(kvm_vm_fd, KVM_CREATE_GUEST_MEMFD, &args);
>     fallocate(fd, 0, 0, 4096);
>     posix_fadvise(fd, 0, 4096, POSIX_FADV_DONTNEED);
> Should guest_memfd implement a .release_folio callback that simply
> returns false to prevent these folios from being evicted?
> --

