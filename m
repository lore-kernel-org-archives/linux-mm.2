Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E045CCA470
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 05:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEAB8E0003; Fri,  3 Oct 2025 01:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FA88E0001; Fri,  3 Oct 2025 01:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD118E0003; Fri,  3 Oct 2025 01:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8238E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 01:29:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FE371403F0
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 05:29:56 +0000 (UTC)
X-FDA: 83955676392.26.9F65FFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6F5E21C0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 05:29:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EIYqlPic;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759469394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5t6kQoNxLFE6ckFDQ5m8USrL/Soot0cxG4lSfuJHKI=;
	b=37eUwEOWqhk4lceg7Vi1QyPjffPfR+bNGT4DiWaui2pGsh3Gb8R+ACeoDR5d4HD+qB3aSS
	gkTl1sTYkUiOLp5+x3vBrLlxmLbDf/Bj3TfzqOqQkvaFHoGJrtRLsX+e9NZJGjIIoeVam8
	BSyfpt0xbZ3pTx5CYkWcPWur6CwTuBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759469394; a=rsa-sha256;
	cv=none;
	b=7HtUr2xOfezLerLKJJ5i+TiKUtCr+wQPDZ72VNCvJk0areYpinYfR2bPImgKJAQdA+4zwC
	Zc6pCqod3eymR2fnXGB7L9T0n+FNfy6pFA6CsaOqHUGCq/ZyG9ohuJ9Mx9kSN7EhBqzumH
	QGiu1RTcdVRSC7oA6KUL7GPBq/Ogww8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EIYqlPic;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759469393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5t6kQoNxLFE6ckFDQ5m8USrL/Soot0cxG4lSfuJHKI=;
	b=EIYqlPic67XaH0mXshi3y4GPIjOi1hvVz+aa3qYdh6T7THhm6nDh/qpQ2Tuc1SDgJr8nS9
	5ZfJeeveCHzj8L2yGu3EcnIQ7aQfj125nC7QPiE3dqK/W+a+FYDjCLOr41XmakAjW0GTao
	MtSOq1xhUQVbPyJjU2YyRJya2Cn4pq8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-EXR_QP-0Mr2DPtIC-6B1MA-1; Fri,
 03 Oct 2025 01:29:50 -0400
X-MC-Unique: EXR_QP-0Mr2DPtIC-6B1MA-1
X-Mimecast-MFC-AGG-ID: EXR_QP-0Mr2DPtIC-6B1MA_1759469389
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEC0E1800447;
	Fri,  3 Oct 2025 05:29:48 +0000 (UTC)
Received: from localhost (unknown [10.72.112.14])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61F381955F19;
	Fri,  3 Oct 2025 05:29:46 +0000 (UTC)
Date: Fri, 3 Oct 2025 13:29:42 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Subject: Re: [PATCH 2/3] mm/swapfile.c: use swap_info[] to find the swap
 device
Message-ID: <aN9fRsoamQ7aWbOl@MiWiFi-R3L-srv>
References: <20251001043436.41338-1-bhe@redhat.com>
 <20251001043436.41338-3-bhe@redhat.com>
 <CACePvbXeFxbtH3c0Wvn56m+wsK0wqxP86ge5Ud73OvqnfDOwMw@mail.gmail.com>
 <aN83NwGpMCFvrOEy@MiWiFi-R3L-srv>
 <CACePvbWgKCjW0fHT03QUXWsj9sV0+1Co9_=t9OWQA5-ApEJyRg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbWgKCjW0fHT03QUXWsj9sV0+1Co9_=t9OWQA5-ApEJyRg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QJki7_T9pSi_CPabh5yvV2nl7dOSglUSt1ylY1LuUek_1759469389
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F5E21C0005
X-Stat-Signature: 3cfwma71o3i53ffecmcwb8j3w8sj9hkz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759469394-214131
X-HE-Meta: U2FsdGVkX1/P3GN8CZD3gYzX1aQB/DQfzrxq+r5WkQZuM40uLoqVnfys1zk7b9va8/DxQxKhWJnGvr31Dc4T3h1eyCZVg/9pRoWl0ouXuTshXKkhaYiCTjEbmmtRdqAP1ZBr032eLFegjZjJhidUEak7r09a8veL2ZegSbdoryE0AnIJmM8V66G8gHauVP7or/c455eWySQovTR16Qu9eqyKF317jUa3Hu/3KrenUPGoE2ov7CklRJE1uqsB5gTJJKGR/OSkiev4r3Uetcv50vasNm3z49Q1/pFqz0/pMdZztGmRY0TvqbF2pYwbPmL+SdCTh/aAxF3G0wc0kvyHXu4ZWNQWfF6aokMt1t8QTBQfVLZL2oKgBtAJn6TuegPf2vscz15vv5AGOK4swFztYCPliU6Tm2AqEa9fnxKoT3Vhg0SnCqZGIFiyD3AnMqss45PcImZ61lWl7lgZijr9uEOwv0FihwgkmPu7gqptTmeX3DZVH2i6ylGsVB3J9YPEaGSIxtWxoF6Yy8OEMEeD2tM7oIzfyy0eZcvoMS84R0njBRRKfrTaoZY+Hc/9MOEH1ov5nrne5klrTQpynvsV3DHvvogPMY3y93sImVmSlLF0fAvvZQzSN4/YcS9OpFBH6xDRnZhxOuDA8/O2ZJUucij7qJsdoiqfDkp5t6Snq1K2FnblyURpY0SEMXpLcBwy/sIg7RmIGzs5BS/qiJS01eE1JiMEj9p6TpMEWz3WwG4GDLHxl+fJ+nvnd64Ut2+ByVvn6jM8qCZUUWmR3n6QpaoZVZy9H+PwNF8bT3ePePcVnJkhYSa4SDmMJi/HrADBoEPRZ9oDZsFipB9u55E/mWuVZ78lYIxI1LKxzZYauDSgCZaTKy4sKDBLcDe2VID1b50tkpVwvMh0nwKEkZ37ltCt5WHzCW3cYb/fhdP/RG5CWJLTmnoXpEiYE3dRuKMMyr8kFhNgJXQ3C4nYfnX
 E+ONhjff
 4XmkwGa8bIr+1vYjLJn4qhfkCREZflfRiDt79nod2LL0Gvdg53VzLQbHXgd6SSJh1zSKp42DCGgZzIDy8D2jCtDk31v2IOF++9V2fDOhYTAEmF7v2ISdTMzSAYAOx5mlILVmy/LCenEvt7hIqSKwiPx0bLJuKzJ8l8ahuVCpEfQGkFtkV/BWVjih5xS8ZARULCdPvFZsd/Of+36LaYkhjjECCTwMAPgVMsamGuegbBqhHywYxg4cYYGJxmQ+iGYuSq2bp3FBa6sbo/JivRbUtdPQNhHKWHBJ8ZAaMFXjshcIlv5kKKV3mwmvNGpLWlNHGQaMDb9YpLa2oKjjqpge/WAEBXSv2VMdB5hrGNgGb4hApCzxqOMRPmkKvGvQ70RgGgi1ZLez81w1m6/9kM7PGgxL1xMPuleMp716W+xDNw0INxNu4LszlUk32SfR+cGj+ePqgtZdPxN5+r8F6k4Ybb7riFXFGxO4FvYGWhGD00ViwD2Y6wErjEiilaBishs2q0yDViMaHxr1Z95kvTyiytHldFqV+mHG6gjWPjWAmsPFCdRx+VOjYLh8LkdN+QdMzQU9k5gnAeh3g/Ew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/02/25 at 09:50pm, Chris Li wrote:
> On Thu, Oct 2, 2025 at 7:39 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 10/02/25 at 08:59am, Chris Li wrote:
> > > On Tue, Sep 30, 2025 at 9:35 PM Baoquan He <bhe@redhat.com> wrote:
> > > >
> > > > Now, swap_active_head is only used to find a present swap device when
> > > > trying to swapoff it. In fact, swap_info[] is a short array which is
> > > > 32 at maximum, and usually the unused one can be reused, so the
> > > > searching for target mostly only iterates the foremost several used
> > > > slots. And swapoff is a rarely used operation, efficiency is not so
> > > > important. Then it's unnecessary to get a plist to make it.
> > > >
> > > > Here go by iterating swap_info[] to find the swap device instead of
> > > > iterating swap_active_head.
> > > >
> > > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > > ---
> > > >  mm/swapfile.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > index 5d71c748a2fe..18b52cc20749 100644
> > > > --- a/mm/swapfile.c
> > > > +++ b/mm/swapfile.c
> > > > @@ -2641,6 +2641,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> > > >         struct inode *inode;
> > > >         struct filename *pathname;
> > > >         int err, found = 0;
> > > > +       unsigned int type;
> > > >
> > > >         if (!capable(CAP_SYS_ADMIN))
> > > >                 return -EPERM;
> > > > @@ -2658,7 +2659,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> > > >
> > > >         mapping = victim->f_mapping;
> > > >         spin_lock(&swap_lock);
> > > > -       plist_for_each_entry(p, &swap_active_head, list) {
> > > > +       for (type = 0; type < nr_swapfiles; type++) {
> > > > +               p = swap_info[type];
> > >
> > > After some careful thinking of the swapoff behavior, I now consider
> > > this patch buggy.
> > >
> > > On behavior change is that, previously the swapoff is dependent on the
> > > swap_active_list and only swapon device is on that list.
> > >
> > > Now you change to enumerate every device at swap off and depend on the
> > > p->flags & SWP_WRITEOK to filter out the device. Which will go through
> > > all 32 swap devices regardless.
> > >
> > > >                 if (p->flags & SWP_WRITEOK) {
> > > >                         if (p->swap_file->f_mapping == mapping) {
> > >
> > > Considering the following race:
> > >
> > > CPU1:
> > > swapoff( "/dev/sda1")
> > > spin_lock(&swap_lock);
> > >
> > > for (type = 0; type < nr_swapfiles; type++) {
> > >      if (p->flags & SWP_WRITEOK) {
> > >          // found the device.
> > > }
> > > ....
> > > spin_lock(&p->lock);
> > > del_from_avail_list(p, true);
> >   ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > plist_del(&p->list, &swap_active_head);
> > > atomic_long_sub(p->pages, &nr_swap_pages);
> > > total_swap_pages -= p->pages;
> > > spin_unlock(&p->lock);
> > > spin_unlock(&swap_lock);
> > >
> > > // at this point the p->flags still have SWP_WRITEOK.
> > > // swap_lock and p->lock are both unlocked.
> >
> > No, SWP_WRITEOK is cleared in del_from_avail_list(). At this point,
> > there's no more SWP_WRITEOK in p->flags when both swap_lock and p->lock
> > are lifted.
> 
> Ah, you are right. I am wrong. I missed the "si->flags &=
> ~SWP_WRITEOK;" inside the del_from_avail_list().
> 
> I read at the end of swapoff it set the si->flags = 0; thinking the
> SWP_WRITEOK was clear there. It is cleared earlier.
> 
> That should be fine. Sorry about the misread.

It's OK, thanks for careful reviewing and checking.


