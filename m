Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3291D10F5D
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8886B0023; Wed, 26 Nov 2025 09:40:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0096B0026; Wed, 26 Nov 2025 09:40:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE276B0027; Wed, 26 Nov 2025 09:40:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C57C6B0023
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:40:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C52971A0613
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:40:33 +0000 (UTC)
X-FDA: 84153019146.23.9323F03
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8A49E40018
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:40:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W4Kze78G;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=89e0yHHa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AkyGfJ65;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6Ks7jppQ;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764168031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHzpYveCHexYyceh16mk4EzoH2BiwwpiWq3vEPFp7iw=;
	b=5NltlxSGKPQWyWLoyj5aEOxBusNWb0+ABMFGYcY7SRWBgzRuvbASIiVBD/w7G3iK94L0hG
	XQWLfzL0kjbOVFX3SY/9Umxtq8aeKoUW+ENds16pnxAcEUkNdC+nPt6/gxPHV9cyzgRbon
	JcqeB/q04VjG4FwSj8Yvg3CkmSC8/PY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764168031; a=rsa-sha256;
	cv=none;
	b=zwu3nmNZb0ALJKBsz2fgSGgCrskTWlIfN9AZhTvcc+qYZQPjtoV43kdx+XbQkdxJhBQDSg
	miwQnp5351sD1ZMhJ3wPwWkLbMTr2+zCoWG30nrPJObBe57V7RCcOUe3N5tK9ymkFWhvR0
	+1woM10d4ykAkyEHRutpe+J4xzHbEOI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W4Kze78G;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=89e0yHHa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AkyGfJ65;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6Ks7jppQ;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E86D35BE2A;
	Wed, 26 Nov 2025 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764168030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yHzpYveCHexYyceh16mk4EzoH2BiwwpiWq3vEPFp7iw=;
	b=W4Kze78Ggk1XZdrjioYv4OSA9OtB/iyAbrQPqgYiDokXfgl7YJHJYuriXsalF8EpHJsN7J
	9azWUwW3EZHMzf3FIguPczF1FeEfONahyka4vOxZrn2SswUsbmNDvrz5Q3UouqDZgzy98n
	zww69ZlzJMq3b5DSX3xJ4sBSa9j3vLA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764168030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yHzpYveCHexYyceh16mk4EzoH2BiwwpiWq3vEPFp7iw=;
	b=89e0yHHaOAI3TozstsupDdbyNi6aYWmXeSD6c72wawHV0jY/8p3NrcyqWRDRGMIpCa0FrL
	6Rxe3ohQ/Z2wFEBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764168029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yHzpYveCHexYyceh16mk4EzoH2BiwwpiWq3vEPFp7iw=;
	b=AkyGfJ65r46GZ5Z464EGX3XiepPBcghOIkZOG1Tz3AySP4p6SrNMlAJbEXyeoAs9wF+TPJ
	HfvVSstXmOduGWZFqycsEeD5jTleqd1EMWwYzv3FDMPAuI1J3vGl3c9FDqbEewpjP4GB0A
	6p+3SNLBfcl2GrAw0zxIBdxxJWu98oM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764168029;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yHzpYveCHexYyceh16mk4EzoH2BiwwpiWq3vEPFp7iw=;
	b=6Ks7jppQNCulmcbo2ihTT0QCVJz6jhGR/gLGBhADoXPX1AzqjdhfSUT02CurFGieUvOAQh
	pw5b/O9bDqDCS1CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC0243EA63;
	Wed, 26 Nov 2025 14:40:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cIeBNV0RJ2mTSgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 26 Nov 2025 14:40:29 +0000
Message-ID: <0f2c5c40-9c70-4b36-b1fa-f211f8ce9529@suse.cz>
Date: Wed, 26 Nov 2025 15:40:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
To: Suren Baghdasaryan <surenb@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <CAJuCfpEge7MJD1joXz=tKgcD7DQgPggjCKF9PLPr3NZEaw=ouw@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <CAJuCfpEge7MJD1joXz=tKgcD7DQgPggjCKF9PLPr3NZEaw=ouw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8A49E40018
X-Stat-Signature: xci36dksz7165z3f683j8q7ae936haoa
X-HE-Tag: 1764168031-93501
X-HE-Meta: U2FsdGVkX18pXP6/cj/AQAd2VeoddvnvlXRaHl0GH5J7yuFfvP/EYiaEslFBstJRz9+UYbmutOqGvZj8+SRH7sCRfAL7bT4r0Zu1E93OBr9Q5ibsjsh89JVns1Wpu8b9jLBWOch/w2dzG52D9yxU7ce9ptU4XI+mcJpZvgjqFFTkU0hWVs7MPFaT9lOOz3qeUNFeAcySZ1TtUO09ZMt4i4o0Ii0TcLD9Hqhp3roV9/t/4ul8vXDa/h6ftHi5jh8Sl+Ez2foHeFJdrEfXPHdX0ADjYczyzIWEB5xhDjev8PHVfgROcqigS4Q0AM4jfNxxkpqcCHUWPg4eCgu6Tx11VOslA5HGA3up2StQwPTI1jCc4qSpsDkNMbI1BNl4X2mb8W5psy0FO12b3U2M6/iAIbQlS++aoKlDN3OySOyspgwtQrn1BnjLOKMPa2LEILbP51eMSCNZmUJs1k8xmqG+pdYqrHkqsp3Yg6ci3KFTisvJDEPwFBnLGC7RrGWCTktud/nc0Cd6Oou01tSbzbSAcervS3Ytvg8ix46GV0GoW2s/0tilYkFj8JPw8z2hSSl/EU3J8UJ79hMaM+o/nYZeY0ol9DSdjlyE5ptQ4xhuQE0D4TpZLHESGHZSeL85w5l+qkNnegDgugn60q51SwKOFsp8Ymh4z6K3ttHqR4q8ycbvYcAC4QjNVqj8RSSl5vdfbfV5lKb5CjSLGYLDsXsKhtgycmLXiAaDRtJwuC40AZDeHs5gnLNltfP/Vzh5m2RLf+ja//F3XBMDlNCCydBlRmd/342dbZyPsgqxis6onSddJXklQCD/vdUsJNKFhqhDk4AmaE4zJLWsVI29acwK125rfJwCWdm4AeGxJ6TpZAbcbfACWoHPerEXfIqBPZgRUILhNGxh7lRseCYSGMnJaZ0Ccpq0ys8zjwZB4E5EkgC3HUH59qQ4erYzsjc8az5U6Xrd2tthWcSASx0775y
 d4F7tvMR
 BEcpMQUIPxw0tQwFkpknm5VPbPQIsAj6bItr5phNvfZfcIumo6gnfzelgXhEZyYkgSPVQjnSi2el9B/Scc44fuIUqo9iDWhKTGNC1ytk8QTYZjtAU5RraPgH+SgiqmA726G7hrmY4WECbDz5cvutFOoRDc6oqnOab3vTRT8T0T+oM5F/treOZGOQH4CmZDXJi/61LxcAa4nYtch1v07FcrUXDsPzD6xj7efEm2ttcvc5fFYuq/9Os2Nanl81mqfo0VzJchrS3HK14fq0D++69IRhvcNGzqvpm44/81W6UQ5nP2ceDvu5PCP1cCILkHJPYjYJdne1T0li6271kQ76pfWUJb30CF+IeIJo8zAeEeIGzBEMXc/++5pJBcJi8yvRgtfc/eHxGXO1SAFal4ItzDtbIfkvrqPbB6Z2Wv8s6Tnug83BPuFK/xMoPQSdL0hxroOA8OvovpwM0fBIw/eW7TWiYImypoNq85Kq9aODZ2BTtND1pjspXlXYt+bOz2SL+5MWXKbdgw+BwI6mTNRz3+1Go3eKwl9jCLrNpDtN4FL28swQzyimFzH3OamwgALpVzHhEGT9IcHefADk2Ivjc9Wjpnkw9UNrcZiprlsnzf/0vV+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 3:26 PM, Suren Baghdasaryan wrote:
> On Tue, Nov 25, 2025 at 8:28 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> On Tue, Nov 25, 2025 at 7:44 PM Matthew Wilcox (Oracle)
>> <willy@infradead.org> wrote:
>>>
>>> If we get a signal, we need to restore the vm_refcnt.  The wrinkle in
>>> that is that we might be the last reference.  If that happens, fix the
>>> refcount to look like we weren't interrupted by a fatal signal.
>>>
>>> Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
>>> Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>> Cc: Suren Baghdasaryan <surenb@google.com>
>>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> ---
>>> Andrew, since the vma_start_write_killable() patch is in mm-stable,
>>> I don't think you can put this in as a fixup, right?
>>>
>>> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
>>
>> Doh! This is embarassing...
>>
>>> Any other stupid thing I've done?  And am I doing the right thing
>>> with refcount_set()?
>>>
>>>  mm/mmap_lock.c | 9 +++++++++
>>>  1 file changed, 9 insertions(+)
>>>
>>> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
>>> index e6e5570d1ec7..71af7f0a5fe1 100644
>>> --- a/mm/mmap_lock.c
>>> +++ b/mm/mmap_lock.c
>>> @@ -74,9 +74,18 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>>>                    refcount_read(&vma->vm_refcnt) == tgt_refcnt,
>>>                    state);
>>>         if (err) {
>>> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
>>> +                       /* Oh cobblers.  While we got a fatal signal, we
>>> +                        * raced with the last user.  Pretend we didn't notice
>>> +                        * the signal
>>> +                        */
>>> +                       refcount_set(&vma->vm_refcnt, VMA_LOCK_OFFSET);
>>> +                       goto acquired;
>>
>> Wait, why do we consider this as a successful acquisition? The
>> vm_refcnt is 0, so this is similar situation to an earlier:
>>
>> if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
>>         return 0;
>>
>> IOW, the vma is not referenced, so we failed to lock it. I think the
>> fix should be:
> 
> After sleeping on it, I don't think we should be masking EINTR error.
> __vma_enter_locked() result might be the only place where an outer
> loop is checking for fatal signals, so returning "failure to lock"
> instead of -EINTR might cause the loop to continue. I think this fix
> would be better:
> 
>           * If vma is detached then only vma_mark_attached() can raise the
>           * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
>           */
> -        if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> +        if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> +                if (fatal_signal_pending(current))
> +                        return -EINTR;

Not necessary IMHO. It could become pending right after we return 0, no
point in testing it here. We should only care about the signals in the
part where we sleep, i.e. rcuwait_wait_event().

>                  return 0;
> +        }
> 
>          rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
>          err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>                     refcount_read(&vma->vm_refcnt) == tgt_refcnt,
>                     state);
>          if (err) {
> +                if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> +                        /*
> +                         * No more users but fatal signal is present,
> +                         * still return the error.
> +                         */
> +                }

Like I said in the other reply, the "no more users" should not happen,
so just WARN_ON_ONCE() on the result, but otherwise agreed.

>                  rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>                  return err;
>          }
> 
> 

