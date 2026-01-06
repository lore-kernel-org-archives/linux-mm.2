Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8800CE9D70
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E836B008A; Tue,  6 Jan 2026 10:56:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45FA36B0093; Tue,  6 Jan 2026 10:56:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3502E6B0095; Tue,  6 Jan 2026 10:56:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22E546B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:56:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF2FA160392
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:56:38 +0000 (UTC)
X-FDA: 84301991676.15.3212E46
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id B9C5540003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:56:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="C1k/bdkX";
	spf=pass (imf17.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767714997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jfb5uISSuVp98mh/bEkrlcNVpu5ATlC+lEdtKuDX1Tw=;
	b=P6O4V+8lLZ8M7SKOyxSvfKTgk9UajOeXFssmu2jfS9ktkgFN2yJQHQ8MzRNSEm1oBzLSmn
	bufEOUdCXfrm0zSejNv+kVcXB9u4snS3hw91C9NPl0Vjebh+qBMZyNbU2hsi55KnfgjWVo
	igOnO6oJOLEWchRFDkloWBJqOCqALWc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="C1k/bdkX";
	spf=pass (imf17.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767714997; a=rsa-sha256;
	cv=none;
	b=LROX4lIu+d/IWJ+Eyza3kb73V75HS9gyp7CWAANsST31Sc/e6bYbkqp61REgpEBHz1WkgJ
	HulseAh8WzTzhzogxJiyp9LQDDjGfPjzMTTjq+UStlE0qgATCWubaltQ5Z5sYuNaD9qqj8
	uiq9E/I+Ji9VGzKMCRar7iEBCJKZmrg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767714996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jfb5uISSuVp98mh/bEkrlcNVpu5ATlC+lEdtKuDX1Tw=;
	b=C1k/bdkXlBPH1qYHbDvdg0E4eWEOyNhXKpMOf1dUMdbfKuWWkxYPaGoc+wq4YadU6ASP4L
	0CswIsdd5gdc1gXabKTTeuC8eifX22PqgTS6IS4lww202Or9FMrpBy+StjUMdszK7HSo5p
	uTItnA/tmbfnoYgbvHNLkrwdY6UYUSM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-178-muEULdYuPmC83zsKbxricg-1; Tue,
 06 Jan 2026 10:56:30 -0500
X-MC-Unique: muEULdYuPmC83zsKbxricg-1
X-Mimecast-MFC-AGG-ID: muEULdYuPmC83zsKbxricg_1767714989
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3E63180028B;
	Tue,  6 Jan 2026 15:56:28 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.153])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D6F5300021A;
	Tue,  6 Jan 2026 15:56:27 +0000 (UTC)
Date: Tue, 6 Jan 2026 10:56:25 -0500
From: Brian Foster <bfoster@redhat.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>, Matthew Wilcox <willy@infradead.org>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
Message-ID: <aV0wqdi3L67LQrcF@bfoster>
References: <20251224094027.65842-1-21cnbao@gmail.com>
 <aUwcV2HhtdiXXxfJ@casper.infradead.org>
 <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
 <bdb7f7c6-ecf5-4da1-a11a-cc19c77fe4f2@linux.alibaba.com>
 <aVvDcEB583Yuolm_@bfoster>
 <2b12f63b-ceab-4d3e-a06f-f41e6b1b2d23@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b12f63b-ceab-4d3e-a06f-f41e6b1b2d23@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9C5540003
X-Stat-Signature: o4u1pab7qjyc4n4tzwka5iaysdxze8bh
X-HE-Tag: 1767714996-699979
X-HE-Meta: U2FsdGVkX19buyUp690wQoTEhCpmQKyFRrs7/PHEDTJdR5OR8WWM79lPG10Jme/0rnxax26dV3k9OUWxMSvZjLrssxpIt7JJ1GyzVkAiJChJw6n4ihNovbYi9GUYQ4TEJoq8tc++rrg45w4pRoQn61PsQeKoU6zDXzmOjisLKlcSg9wV0c+7w9k7tHqkvAX1NL1JKQ3uGLSTB/ZmIMonrDaqZjufjspXmxuDhscTfyXyJUdH9eye112s9RWC2AImKTvCC93ovRTOwceGjw5Zbrjnv8F6u8IQQ/19rY7vk4IqfAFBLk5yIiY9RaO2gmfDYhHjfkltw8Rn1A8XaIv9aCPVBTZt9fh84+zhHnVQPewYNdiWyQRZh/5AWW9hWEmLvnQrMQxFvR3JUyjH021LIEfrz7xTDaa29BhS9/wV5HBhTMWVdkc0+BcrBk/tyzmBAIiOq+7EudssDW5Su4L6Vrvjj0U4Qwc6a616xoYwqLa0lWZBts2VVo+slOs1jH5DROgt9osSwfQHu4mHsYcekVO71ZSJGWUgQn1SiHIV55UnvBq2p+ncaIUziIrUgV5HNwGaYrTPbYwWGsLC6aZKvpjfezLBOSSUxZbHBz/qDTTvv+dLYGRycXeWKfsXoNX5f4HCqLz84HK60eT57RhmKuXpikB2eDukd7YqFUDoZrVwtlug1aks6/8mUGCqqTfjyzUdp+8DkAQjmcAIj7dBAnPciXrsYw4kXs2BTq2A9qHIphHgtdOXaWOUvGbZIhsUpDMULo0kpcj01zZGMolqMY3M9GFkOpq7i9nGCXnw0/vHaVANofFH8O2s9l32dZvwuVp0XuKq2HxSSO7a3ZAJGgs3xh/5/2eK5pk6BmsJ9RqZGgSgPQAmbNVL9im1T1BQVGJoJupk3cMvBmExyqV/1yGxVP3sEx3xC5bOczXN7c3DTqL9zNaH/SdlENYH0HiIQqxP/rIfgImGJLajAOq
 nTi8mRcD
 blOo2j2AHj59lyBHU4LsYKR4Kh9ezuYSYU07P3Z3R3EzvQM1/A0miQNVOqj4JiZXSlky/upKTsfVO4+X7XQqNz2vqAD27mG+vOUAIZGO7MjWh890E/1N7mAt7wWMkQus1TZRewxzqCJn6sroRAXqH8pQ24M/G965V8y+7tSFKY0FpzBaoVMDZghRuWAaQOo7W8I3496IL79pFB6U6gr2zQ8UPH7AUVIODte8BSG5l3pUSl5sN/uF1IqLerrTHe28cMSeIT6W9gGSlpkqewRHhdK5J2G1k9xahck6LYN21lVvByoAZxd4IIxPP+PMvzsqVb56/uvQck5l30WPa/f29aOpHgYrh5jwaOxnye8nvLJAKStPmDJs1QwgX9NvVkJ1J/m1j0m3czQ0iWsfdFh3NJBcoI3un14MQVogtbx2lXFbJtM0eZMrp8wVctnvfChe44ARa/koBbBmj9JbKXmDOTUv5nS8IW//rflETBCdmx90U2J44dHzXB8x9dxzUHro350CeXqg/3CjKhUSmdVQvSMDqyTFiujXMjtW9LLllkTKnD1j40q8AnYY29VBxj+blr/6mQRMomxd3XJq4rCc/KQBKKNjSOgR6toN/qifb7Tk7HgkXP9f4xh3RuXfhmsR/ICnE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 11:47:44AM +0800, Baolin Wang wrote:
> 
> 
> On 1/5/26 9:58 PM, Brian Foster wrote:
> > On Thu, Dec 25, 2025 at 06:08:08PM +0800, Baolin Wang wrote:
> > > 
> > > 
> > > On 2025/12/25 12:04, Barry Song wrote:
> > > > On Thu, Dec 25, 2025 at 6:01 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > > > 
> > > > > On Wed, Dec 24, 2025 at 10:40:27PM +1300, Barry Song wrote:
> > > > > > From: Barry Song <baohua@kernel.org>
> > > > > > 
> > > > > > Uninitialized folio allocated in shmem_symlink() may be accessed
> > > > > > during swap-out, causing KMSAN BUG:
> > > > > 
> > > > > This would be an unfortunate way to fix it.  The vast majority of
> > > > > symlinks are short, and we'll never access past the \0 in normal
> > > > > operation, so we'll be dirtying a lot of cachelines essentially to (1)
> > > > > shut up an automated tool and (2) optimise a corner case.
> > > > > 
> > > > > How about this instead which delays zeroing to swapout?
> > > > 
> > > > Matthew, thank you very much for your review, even during Christmas.
> > > > I would like to wish you a happy holiday!
> > > > 
> > > > I am not quite sure, as shm symlinks do not seem very common. Since
> > > > allocating a folio requires a symname longer than 128 bytes (where
> > > > 128 == SHORT_SYMLINK_LEN), such cases appear even rarer.
> > > > 
> > > > BTW, do we need to migrate the owner_2 flag in folio_migrate_flags()?
> > > > If so, I am not quite sure it is worth changing the hotpath to
> > > > accommodate this.
> > > 
> > > +1. At least for me, using the 'PG_owner_2' flag alone to mark this uncommon
> > > case doesn't seem quite worthwhile.
> > > 
> > 
> > Also JFYI the post-eof swapout zeroing work (still pending) looks to me
> > like it would cover the swapout time case [1]. That's just if you wanted
> > to go that route here; creation time zeroing for the large symlink case
> > seems reasonable enough to me as well.
> 
> IMHO, your post-eof zeroing work is intended to zero !uptodate or beyond EOF
> folios before swap-out, however, the symlink folio is uptodate and not
> beyond the EOF. I am not sure if it will make your code more complicated
> when you want to cover this symlink case.
> 

It already handles this particular case. The primary intent is to zero
all post-eof ranges that can be written out before that write out
happens. I.e., if you take a look at shmem_writeout(), if the folio
happens to straddle i_size we zero from i_size to the end of the folio.

> Why I prefer Barry's fix: First, the symlink folio is marked Uptodate after
> copying the symlink name, but the whole folio hasn’t been initialized, which
> seems unreasonable to me. Second, as I said before, using the 'PG_owner_2'
> flag to mark this uncommon case doesn’t seem worthwhile. Currently, IIUC the
> 'PG_owner_2' is only used by btrfs; if we ever want to remove the
> 'PG_owner_2', this uncommon symlink case shouldn’t block its removal.
> 

I think we're talking past eachother a bit here. ;) I'm pointing out
that outstanding work already covers writeout time zeroing so as to
avoid duplicate effort if this was trending that way. IOW, I think
there's no reason to consider the page flag thing, it's more of a
question of do you want the zeroing at creation time or not..

I again don't have a strong opinion on this, but I think I can see
justification either way. If the focus is a KMSAN splat at writeout
time, then it makes some sense to address it in that slower/less likely
path.

That said, if we step back and consider that if this were a buffered
write we'd tail zero the folio at write time before marking it uptodate,
this seems like more broadly consistent behavior with other fs' and
operations. This would be analogous to say XFS allocating a zeroed
metadata buffer on symlink creation to ensure the underlying block is
tail zeroed before it is eventually written to disk. 

So to your point, maybe the most appropriate thing to do is cover
zeroing in both places..

> BTW, as I said before, I've reviewed and tested your post-eof work[1]. Maybe
> you could resend the patch set so that Hugh can take a look when he has
> time.
> 

Yeah.. I know Hugh is busy and that isn't the highest priority series.
I'm just catching back up from time off myself so I can give it more
time before I repost it or anything.

Brian

> > [1] https://lore.kernel.org/linux-mm/20251121152246.1023918-3-bfoster@redhat.com/
> > 
> > > > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > > > index ec6c01378e9d..f3b3be1b50fe 100644
> > > > > --- a/mm/shmem.c
> > > > > +++ b/mm/shmem.c
> > > > > @@ -1636,6 +1636,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> > > > >                   folio_mark_uptodate(folio);
> > > > >           }
> > > > > 
> > > > > +       /* Zero out symlink tails to help with compression */
> > > > > +       if (folio_test_owner_2(folio)) {
> > > > > +               struct inode *inode = folio->mapping->host;
> > > > > +               folio_zero_segment(folio, inode->i_size, folio_size(folio));
> > > > > +               folio_clear_owner_2(folio);
> > > > > +       }
> > > > > +
> > > > >           if (!folio_alloc_swap(folio)) {
> > > > >                   bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
> > > > >                   int error;
> > > > > @@ -4133,6 +4140,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
> > > > >                   memcpy(folio_address(folio), symname, len);
> > > > >                   folio_mark_uptodate(folio);
> > > > >                   folio_mark_dirty(folio);
> > > > > +               folio_set_owner_2(folio);
> > > > >                   folio_unlock(folio);
> > > > >                   folio_put(folio);
> > > > >           }
> > > > 
> > > > Thanks
> > > > Barry
> > > 
> > > 
> 


