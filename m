Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA854CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 02:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233E78E0005; Thu,  2 Oct 2025 22:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4FC8E0001; Thu,  2 Oct 2025 22:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC038E0005; Thu,  2 Oct 2025 22:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E66D88E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:55:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 601F713B9E9
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:39:00 +0000 (UTC)
X-FDA: 83955245640.05.EF154D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4FF69C000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:38:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AdqGwVSx;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759459138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFxohDVox4L5XA/iD/+dEFf1PlFaKFj0XVzXne3jOZE=;
	b=l3J2MYX2pi+rocg5ASVpLFXfV2qKoNTYFgwfDr3+wlYNjPpXFkDSR0lN6Xe6yKtmgCjJUB
	Gum+iQ0gzJIfA/wscDYXDHbcf66WB4QETifw28biU8nqmeofCv3/k435rX9xZT9gVkAp/0
	ohqOQ/N97FvkLLPPzJnONI4+ew9qqYs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AdqGwVSx;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759459138; a=rsa-sha256;
	cv=none;
	b=og4/WPo48hpS0mt6Q8lpGPsH0OhFLdg/31Un9LbttmoThfWUmbwBWYtrWyn8c+ADT5DU48
	sIDxyTHEVgC7u/Xpn+gjjn0Tj/0wzc8Te4OTTW2nKFsWC1Gnz97lkBh9BbFZd3tBnsRKqe
	xdCqNYHhKFIJEXQwe4MzBo/gj8n79SY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759459137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rFxohDVox4L5XA/iD/+dEFf1PlFaKFj0XVzXne3jOZE=;
	b=AdqGwVSxnTmTheR8Edp9X1LlyaX94QQnx42unb81vla3ttwV4Z1ZqwSmSSOUp5KWtGS4DY
	1MX7gQMHdDkU48natT7U61lsSNkZy6DCieA/XsWXs3JUBxmuFhawSMR+5DJH5lsqSABgYs
	9qzXQSDUnguCRbUc819mIrqzBJe1YOs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-Ukzc7XblM3K0PKOF2pjLrw-1; Thu,
 02 Oct 2025 22:38:55 -0400
X-MC-Unique: Ukzc7XblM3K0PKOF2pjLrw-1
X-Mimecast-MFC-AGG-ID: Ukzc7XblM3K0PKOF2pjLrw_1759459133
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 436151800366;
	Fri,  3 Oct 2025 02:38:53 +0000 (UTC)
Received: from localhost (unknown [10.72.112.14])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA61E1953943;
	Fri,  3 Oct 2025 02:38:51 +0000 (UTC)
Date: Fri, 3 Oct 2025 10:38:47 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Subject: Re: [PATCH 2/3] mm/swapfile.c: use swap_info[] to find the swap
 device
Message-ID: <aN83NwGpMCFvrOEy@MiWiFi-R3L-srv>
References: <20251001043436.41338-1-bhe@redhat.com>
 <20251001043436.41338-3-bhe@redhat.com>
 <CACePvbXeFxbtH3c0Wvn56m+wsK0wqxP86ge5Ud73OvqnfDOwMw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbXeFxbtH3c0Wvn56m+wsK0wqxP86ge5Ud73OvqnfDOwMw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FpugmBKQkYJioUnT6sMz44S-9jdALHKT1AA_EXKOD0w_1759459133
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4FF69C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5tzieyg8un8ksock8hkz5uardt7zch38
X-HE-Tag: 1759459138-873754
X-HE-Meta: U2FsdGVkX19klKNOqRevdp1JJnoUH9kCytrjFbEWdoIDcr54OM55KqBNNmaDrXipBX8TGGGGGJLlAxhIduJztRPZynxPWYlZrVoWNYPw0El0+doZc8aQMoMPyYotkrxb8K9kGfzJhS5BxckrB0xKDdyxCqHI0Su1sc/KBPJ/NViRsJw5XBY5qfIkhXq191esesFAX674B1BBxq+RbTNjGkaB0SVwSt5mHsmgWn5mG2SgndPENrVkxtRI9gWqVITCgIMA2hAKh/a/g9Ml/xBl7e8lZDlL4ShrRfSEkcymKxowSzgWGa4duYiMR53KpEKZDapITZZmUOby+kBQg6z0gUk6sBciCJsCKMaVr9cxU9JEs1veorioJ4ADCRqNP/UeWPfPnY8knCnl/uiVUZvepLpM5hegNQNTho2uKHBzvhNNTteyMBESmPyzMKmtvL9xvvwovpV0R+1yyXiGiTYyo5DMttbQwXK161fJqnzw7xWI0zDhxG11OOV0uJI/TwD5xbj8bCOl0DL5wMVFKyanSaH7aqUembtPBqYEn0pij4DLkVoBed/7vaJkmD8bAAIO8LVumpNPGFU3cco8bSe6kfNTeK1aIWBhir3tHml2GOBWmA5L/qd6cJidOob6AiTQr8GgOIWkdHhwKOaJ1bvbH57FJldK5K0tBazkOw/lOcG/+bs52PSPWKHaTF70UtUJ15oz3VrePi6slDLicerOx9ZIFRyX1/fP2NMqaRsEI+PXRUI/UqEb0Wt1gRH+XthGuq13VHITMCrQYDl1+YxOq52E4DPk7zr9fkLImkY8yxhOOUhDRu89YA3pcS+zg2ne6WT+VCwk/YzCvPRyOy552bIe/p9rryjeVTFKODOBo8GJz4Mh7B6qr0XbJi8ZyvLm5gGS7x4Jiqz1LdihtP+Tyj/wGnfRXpMa38zPHFMITws/n3wZ+x5JgmFXbqq2UMnP6Wd3tVgE6gb7K3T5W4A
 T1S8MHox
 UUm2+TPYkfy+ahi5MPzMnUjLh1kSjb7a68Hgwp7f03bwfHRGkXAug7sFiG86kXG0K2nkhZj4L2vOXY+W0OXITZp8MZogJm9SUvdiqfTkxiT2Nfu3EPT1rHjaxqVTmsTetpsgRyayujt39d4OmzFHSwaqJnQ2SLIqkZ/hDva13zVGXOxV+OJWF+wKh9omjKyfLthLqP5WugftxQNgXks43udyCbdgLKsDpBoBVCqbp2BMmP3QIxq0GsMligb1Ldd8LAbLQ/VwwwwvGHa1ZzPioX2rw35QByRc0k/OxFvuciVsefT5lsb3y5A4qorHf879S5MaigGQhxz8vnyuFTzaekpBqIYInbNAysx4EgtNFmMPLTW2E9qvbevIybuUZYUqP/SMiV9FiIbNzMG0VJyNvGmLbjpKUC3ygKqFqAN26Rns383THvaBXpduL8MmAceufS/E4UlExx1Ogmz7z94tgs8Lw9ckajUbiCl0b3qSX9j+7JwT4ttoxXspZ+GnLrrM6NDeqtm4VYVS/n2uGLRJZKVsmP4VDj+i0yA0WUDhocYQdU78rA6AxmUlgRSgTBYyfxDXe8KRcbtZkMY4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/02/25 at 08:59am, Chris Li wrote:
> On Tue, Sep 30, 2025 at 9:35 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > Now, swap_active_head is only used to find a present swap device when
> > trying to swapoff it. In fact, swap_info[] is a short array which is
> > 32 at maximum, and usually the unused one can be reused, so the
> > searching for target mostly only iterates the foremost several used
> > slots. And swapoff is a rarely used operation, efficiency is not so
> > important. Then it's unnecessary to get a plist to make it.
> >
> > Here go by iterating swap_info[] to find the swap device instead of
> > iterating swap_active_head.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  mm/swapfile.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 5d71c748a2fe..18b52cc20749 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -2641,6 +2641,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >         struct inode *inode;
> >         struct filename *pathname;
> >         int err, found = 0;
> > +       unsigned int type;
> >
> >         if (!capable(CAP_SYS_ADMIN))
> >                 return -EPERM;
> > @@ -2658,7 +2659,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >
> >         mapping = victim->f_mapping;
> >         spin_lock(&swap_lock);
> > -       plist_for_each_entry(p, &swap_active_head, list) {
> > +       for (type = 0; type < nr_swapfiles; type++) {
> > +               p = swap_info[type];
> 
> After some careful thinking of the swapoff behavior, I now consider
> this patch buggy.
> 
> On behavior change is that, previously the swapoff is dependent on the
> swap_active_list and only swapon device is on that list.
> 
> Now you change to enumerate every device at swap off and depend on the
> p->flags & SWP_WRITEOK to filter out the device. Which will go through
> all 32 swap devices regardless.
> 
> >                 if (p->flags & SWP_WRITEOK) {
> >                         if (p->swap_file->f_mapping == mapping) {
> 
> Considering the following race:
> 
> CPU1:
> swapoff( "/dev/sda1")
> spin_lock(&swap_lock);
> 
> for (type = 0; type < nr_swapfiles; type++) {
>      if (p->flags & SWP_WRITEOK) {
>          // found the device.
> }
> ....
> spin_lock(&p->lock);
> del_from_avail_list(p, true);
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> plist_del(&p->list, &swap_active_head);
> atomic_long_sub(p->pages, &nr_swap_pages);
> total_swap_pages -= p->pages;
> spin_unlock(&p->lock);
> spin_unlock(&swap_lock);
> 
> // at this point the p->flags still have SWP_WRITEOK.
> // swap_lock and p->lock are both unlocked.

No, SWP_WRITEOK is cleared in del_from_avail_list(). At this point,
there's no more SWP_WRITEOK in p->flags when both swap_lock and p->lock
are lifted.

> 
> Now the second CPU swapoff race begins
> 
>                                                        CPU2:
>                                                        swapoff( "/dev/sda1")
> 
> spin_lock(&swap_lock); // can take this lock
> 
>                                                        for (type = 0;
> type < nr_swapfiles; type++) {
>                                                        if (p->flags &
> SWP_WRITEOK) {
>                                                               // also
> found the device. because p->flags are not clear to 0 yet.
>                                                        }
>                                                        ....
> 
> spin_lock(&p->lock); // can also take this lock
> 
> del_from_avail_list(p, true);
> 
> plist_del(&p->list, &swap_active_head); <=== blow up here
>                                                        // remove p not
> the in list.
> 
> atomic_long_sub(p->pages, &nr_swap_pages);
>                                                        // double subtracting ..
> 
> total_swap_pages -= p->pages;
>                                                        // double
> subtracting as well.
>                                                        spin_unlock(&p->lock);
>                                                        spin_unlock(&swap_lock);
> 
> Please confirm or deny if that race is possible.
> If it is, consider it a NACK to this patch.
> 
> Please consider that even trivial patches can have subtle behavior
> change and it has non zero cost to reviewers. It can introduce subtle
> bugs unintentionally as well. In this case, I feel that the
> gain(removing a list, total less than 1K) is too small,  not a very
> good return on investment.
> 
> Chris
> 


