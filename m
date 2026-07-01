Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FB7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408EF6B00A6; Wed,  1 Jul 2026 05:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E05B6B00A8; Wed,  1 Jul 2026 05:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1466B00AE; Wed,  1 Jul 2026 05:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0633F6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:52:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 721311402CC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:52:10 +0000 (UTC)
X-FDA: 84939742020.25.AC679AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D898E12000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:52:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUmFUbpx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782899528;
	b=uyoVQehJR0I+qlwL2wrW1jI6aueuyODehx2vFmPRu0nEkbNhuqCT1D6+0UIitza/3xtY0i
	TAnylYMTT3LuJnBK225+BjXK5cCDlR5vWesk3L5it3UTTmOBO5s5XqqnwJ9lC9Its5L2vj
	vtKIwbemdlN9N34hOkN2fgKvB61slZU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782899528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6AeWjVLYlFF7ljuv59DbbHj2vnwHWY4jNzYXr4Sv7xs=;
	b=nNHhLswXA2uSxcL8a30+/JW9lyB/F0y5jgpZuu93zPkcZhywAkcQVa8+JfEaxvWmSg2UZI
	mLqMThJP14i1HDFQUQdY3H5Pp/ChQD/+EEDMXiZpUnkWyCaMdUT56uR1zj2HAq3xXPpBdW
	1TFgix8owUEIwWXi8I1zDfb77bjdv6I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUmFUbpx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21C74417C7;
	Wed,  1 Jul 2026 09:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DE91F00A3A;
	Wed,  1 Jul 2026 09:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782899528;
	bh=6AeWjVLYlFF7ljuv59DbbHj2vnwHWY4jNzYXr4Sv7xs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hUmFUbpx1y5tJpPtnUlhcT3j1560TB5Z7WidudXQhnXQ3iBlDbOGKHdvOXxORwcrE
	 tjmyXJMPH48NxKfebsrBvhUG7gACJwmZBgrQpAIcWhb5oG4zMfdDkGNOqXzmcJIxMZ
	 oFwE09qRkgyihGrox9lPD0M8pJPvZztnF7f92f8U84bzcQesV6RBPrds9JSGEOpWhf
	 qER8uTWo8wRBJgWEBBXX4UndrcxMWK4GJPF99H/7QvmN4QI4razDO5GnzxBRwUy9tZ
	 AH6UDHXZu9FYrBnZ8aE8ywkTbnCASgfyFqy+cxTE0e0MnA26p6ifh1mSGu+DbB+2e8
	 Okad/FnnS81yw==
Date: Wed, 1 Jul 2026 12:52:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hannes Reinecke <hare@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
Message-ID: <akTjQVQQNdeO9M28@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D898E12000C
X-Rspam-User: 
X-Stat-Signature: jry34g8wuzjfmgytsy3ieobwsyzrmx19
X-HE-Tag: 1782899528-39004
X-HE-Meta: U2FsdGVkX199KZ0BD14kamasRmIoPVjMBXA20ueFFJViy/GVo1U5bd90cBZHy0EfiZHQB0/opR5wFviLiU+Bnp3qS+tDIcfeekfU8Hns1bW2Kk/1RQsXyyX+UNMy7PAE2QQXjX6jqRqCHeAKKKuHlAAA52sU99bcOH+xbYwXiivWdZ+946tKvLb7LTBCW6r4gjQlw7vHNRNj8eg+uMgsnHpO67a12OmBw/ip1NA3JPFym8FG5gMNVRDbmDwYnE4a0bb8Cg5JfD6yNTc8D6a2PFfXjIgThPqgrJaF9goOiAvUh+1RTvx32DcaRG78MQFzc43ja/cGlwd63fWVrE1j0L9jVuYZeROLblSh7EXPhk8ceiRGsHnjW/BvenooMSAzjKyJu1OmN5lGb/cJZBjksIH+yitSYAbbZs0B7Qimtwx+oSap7HuM9C0jjfp1WZP+iyDp/8AMI66iiH4/gME3SQUxyniwsLEyUHp13qJJdK751pM9t1yUHjQQUBsr+L6jnXJX83LAjlglRxhow3sDLkjUVVwecVWlXJpawtonBo3w9EBzr6nmerndi6dJ7hnKZszUhle/YwSsp+f6BgSW6VYzSqXWbapB9bKegk23NztibMDc+54Hs3niAsabmqVAfGSpAOg7PCjo8kiPWk7+oj26vV4VIqJ3sWDJwZC3CgUHrtOuya3EQhJJx6bv7sP6FscwdeJOIDR1T+9nInJOvTajZT8mBe4cX69o2VKnblVZqQUbTGUfh3xRsWfNtzxDgE9pfHMDSwP+73Wl6OgdrgtJWbBrB087KbyIGxs0bjdd8DnDNsnCbW/BymOcPL3B8uTv7e2mSdPWyn6rXMt+e+IYCqCFtebkMeZwe0W9+8fw8OVGqPn2ixndN9X3usXGZlOTOrKgXnQuJnak46IZ+gEvJ4laVqWLM2XJ5Ljr268KlmWNLabG53UQP0NCXXdzJk0hGwVd5hh0+ujmCp5
 mO64OjRg
 xn3sP8yCLjw2DZfkivi89oSPwWAjjJibw7J4I5fnksn3SCr8oZ4dfXYr/ixMnIi9n+J+IK32qqOcRUn8416pQPJbfFRQ8ORmxyMCx1PgBcrPuEi5xD87hD959xNFIvQG95oa2h6RqC1WNHRicR843Nk4jQ+KXtyumozszhRsk7V0BltEeLNgOiaHnn6KhCtf7xRvQuvlLK1xjB6vTvdpc89hKRNmYX8fXd+pcwSv10PGGR9mfCKuTZDBv1qKHzMoEsCFwaNi3Zqw6X0nQUl1RujeiFoonJ6seVADYAEpeyEJsSIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> > IPR dump machinery allocates memory to save adapter's crash dump using
> > __get_free_page().
> > 
> > This memory can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Replace use of __get_free_page() with kmalloc().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   drivers/scsi/ipr.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> > index d207e5e81afe..5a212bfdeec2 100644
> > --- a/drivers/scsi/ipr.c
> > +++ b/drivers/scsi/ipr.c
> > @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
> >   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
> >   		if (ioa_dump->page_offset >= PAGE_SIZE ||
> >   		    ioa_dump->page_offset == 0) {
> > -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
> > +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> >   			if (!page) {
> >   				ipr_trace;
> > @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
> >   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> >   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
> > -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
> > +		kfree(dump->ioa_dump.ioa_data[i]);
> >   	vfree(dump->ioa_dump.ioa_data);
> >   	kfree(dump);
> > 
>
> I _think_ we can replace this with kvmalloc, and allocate the entire
> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
> to allocate separate page-sized buffers here.

kmalloc() performance is on par with __get_free_page(), but kvmalloc()
would be slower if it falls back to vmalloc(). 

I'm not familiar with the driver to say if this could be an issue here.
 
> Cheers,
> Hannes

-- 
Sincerely yours,
Mike.

