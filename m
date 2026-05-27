Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C97CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5172E6B00BC; Wed, 27 May 2026 11:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1506B00BE; Wed, 27 May 2026 11:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3427A6B00BF; Wed, 27 May 2026 11:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1EAAA6B00BC
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:19:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5B56C219C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:19:56 +0000 (UTC)
X-FDA: 84813559992.06.1A4D216
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 75BFB16000E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:19:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G60dGfiu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JXqGt6rB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zIUv+g9U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="7vmZ/7qa";
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779895194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQiTEJXQCo0W3Pij3gX2zcUEPyaYgtCBaa/1OBFdGbM=;
	b=hFOngHxmtuWDc6v5edOtUXmW1nNt7HRPBAarH3b8blZFJQpTMK/rsBLOXWJ/yZ6Ydmn+so
	pRrDJ7iaZXAgn9oIqiQOWeUfiYmktHXaCFOBpMd45YO4OncXK+Mfl+143DK8fEhU35xV+M
	7qxrHZbSbuKrJeH0R6cYru3auA3kRVE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G60dGfiu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JXqGt6rB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zIUv+g9U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="7vmZ/7qa";
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779895194; a=rsa-sha256;
	cv=none;
	b=TdeAFD9l5S+VI1TWLJTnrvWlK5saY+EXazoyoMQpD4zepCC3yMKpsVmXvbIMcCUAhO8ARM
	PGCaSazCIiyh9lklh0P+l0Dz6Yrz/bjmZZUlIl/CM1dUTQ2emUdHetIvS6w+2Wn2CabdPW
	Pe4KrMSGbzKr88sCSS8Vxm78WoMLhDU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AB62A66D97;
	Wed, 27 May 2026 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779895192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VQiTEJXQCo0W3Pij3gX2zcUEPyaYgtCBaa/1OBFdGbM=;
	b=G60dGfiudDBTTsAKbv24NKXMC4mrIvYbAdoAaKKIoXbdZYiVoiPXO0dK/JwiIld3FLH5H/
	EXR/ET0nRYZO6lIBhmyyCGJbZ94tIjGheZGcFbH4TCE3KUuundnwalgvV1xmvPQTq1db26
	y9ymEj0lyXmOPzZh+AgZ2fS+bIAj2jI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779895192;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VQiTEJXQCo0W3Pij3gX2zcUEPyaYgtCBaa/1OBFdGbM=;
	b=JXqGt6rBv5Jn2ZbFvXHMNaG/ErJHbfARWfNAIPxappIZO6khTTLMQuxF4f80H/nyTQ6+bM
	5DgwU2S9MNpcYIAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779895188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VQiTEJXQCo0W3Pij3gX2zcUEPyaYgtCBaa/1OBFdGbM=;
	b=zIUv+g9Umg/gd0pUxixdqohcCZ7497kV1EPHhMEEELaQIUxVR86QnD+Kb4QCugaqCnCae7
	ZqHv8dZfK445Ckr1FfHypKVmHgYjBKWeFD3JTu6f9tiwaJdXDg/z4uhOEKhio/4RvJXyPC
	9kmf+XpO9mJccrVWFq8LGwyWUojjyS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779895188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VQiTEJXQCo0W3Pij3gX2zcUEPyaYgtCBaa/1OBFdGbM=;
	b=7vmZ/7qaGd4SZENaMEjQ1P/SsNA9vjYY2ZkExEk+SIR/fcXG2onLSZDx+++bnV6bzE76lF
	muBEXM4Krtknd1BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46E765A8C5;
	Wed, 27 May 2026 15:19:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pvb/D5QLF2plGQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 27 May 2026 15:19:48 +0000
Message-ID: <326ebdd3-308a-4eda-b75d-64d789f91881@suse.de>
Date: Wed, 27 May 2026 17:19:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Igor Torrente <igor.torrente@collabora.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
Cc: loic.molinari@collabora.com, willy@infradead.org, frank.binns@imgtec.com,
 matt.coster@imgtec.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260209133241.238813-1-tzimmermann@suse.de>
 <20260209133241.238813-6-tzimmermann@suse.de>
 <d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
 <850e8355-7884-405c-a70a-986ce032c019@suse.de>
 <831c0943-c75f-4d42-aa5f-90ce34cf8530@collabora.com>
 <67855fcd-2afe-4a1d-a51a-210e45f56167@suse.de>
 <20260527121832.7264f0db@fedora>
 <025ee28d-c941-4cf1-a6cf-565686ea0bec@suse.de>
 <16cbd262-aa82-4ca7-ac12-d587ed78ff3b@collabora.com>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <16cbd262-aa82-4ca7-ac12-d587ed78ff3b@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: nh6sb3zmhu3cg5zc595zo8h8ou1e3i77
X-Rspamd-Queue-Id: 75BFB16000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779895194-936931
X-HE-Meta: U2FsdGVkX1+/RSj8lUN4/bVnB69KD1sf4MwIGr0rld6L8p9xLmjKjeIeJJOO33ciBSVsJ/OgeQqS9/P69wcyOg8VFFsXTou+GBRoz8qhSyu+bn+UcXifKNOftFKGCh7oT3xZBTSLlYKbo8s0l5m1YO1h190TF3/8zUSc6efD7UW1+aZG7OTtSJyn9vJBosHuf1lTSznXqtoSY9joRYfOipPHZFQgL+QL/Chx7n7Ta9S68azN8gAzBFLlHuLVLzcV9lsSJru+kKZNXQ7lkSS6xJEaZaNcEvb0Dl6+irJ8LYQhOQoMWMdAti+1cKB+6YrF9jbkNxoWOBL337qfB8Nuuy3Rn9CjEF7leRHRLR9OPMQyfa2M6H9MHCbQ7xIOBrJJEQjZwwWxoG6k4I3+8h3Uv4fbtoKTUzd91+ljFxKdMaVSlnnKmQ9UH01l049ADsg1zirI39G0gFQJOvhFBgrLMJmVJoh2V55kdFObDt5OQ4plj9TSmduPbCE7u/rHSxAkTF7now16JvknUiWtmcr+cng23yOS1AON9xZe2VZqAWPXwx7r5nxs+GumVD3yhqaEEKeIvrWwjtzQuJWp6PIj902BzVolWB3h4+tAl+4BRelfXkEvHVpQhNq2zQu4b0JLzpXWnaN30MbPVigRr+VyebZlpLNHTmN4qH+kUf6Sz33sSUc9XSKoAGjnY3SJUsfyeprAowY0jgFt1nLBgkaHXRtorSbu5T3LAjpft4K7K1B+nUzaINFRpG5OjL/gOI7CUmvZSYxcnk2Eyc7plweCEj436IkY4dexeX1uHnFuUzCv7gM6OeFiY2hCnjsMNSN2283+LpJ1ws/iAaUGO7TUqPjxyituuMcrQpxLE9TBZ684FZq5x6yYMZHGVMYoCusfW+eALzd2LCTnr3pgDOvB3IYYSqmObtVXpiU+l3r6AViG9Bt3I0BN/ltpomrkoDT4WJJisbM4FdLKe/VcXSS
 7xbyLtsH
 SpJyOApXyKc+U5Aj2v5sJru9pT+UDnXwK2sr1Hf0balmWNc7STylndk2w2L5CqJTnys8jmvyBTEsldStw1TNqPMllDN086cPbRG14pLBzNUeoHNhUKbguDotNRWoziXmP+vLPRlAPuC6vrcloJYof/o83HpvO3g7wjKuAtED8lBJhAPy5S1gHze7Q+kN/47gGr8hEHwDm5bkQBLOR9WZHo2gKN5gZPqWihYcKIQj+Ng30y9g3MAZghQkX+IjptuaRkPkalJ53d+swejOM26YaJA/x6zFMOTioVUguqaX+6QjFO0QfYJQjZij9jpHx+kfy9P90TyT0x5/01jX59NZshP5XXQ+87OaTjUXiT96NDHisUeqagpmkoQfQThXBfwsidKyqzWkViBxHoX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 27.05.26 um 17:02 schrieb Igor Torrente:
> Hi Tomas,
>
> I tested your patch and Boris's modifications on top of your patch, and
> I'm happy to report that both seem to work just fine.

Thanks a lot for testing. I'll send out the official patch ASAP.

Best regards
Thomas

>
> BR,
> Igor Torrente
>
> On 5/27/26 07:32, Thomas Zimmermann wrote:
>> Hi
>>
>> Am 27.05.26 um 12:18 schrieb Boris Brezillon:
>>> Hello Thomas,
>>>
>>> I'm inlining the diff you posted so I can comment on it directly before
>>> it's officially posted to the list.
>>
>> Thanks, I'll incorporate those in the next test rev or the official 
>> patch.
>>
>> Best regards
>> Thomas
>>
>>>
>>> On Wed, 27 May 2026 08:56:33 +0200
>>> Thomas Zimmermann <tzimmermann@suse.de> wrote:
>>>
>>>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c 
>>>> b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> index 545933c7f712..07e117673124 100644
>>>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> @@ -554,21 +554,6 @@ int drm_gem_shmem_dumb_create(struct drm_file 
>>>> *file, struct drm_device *dev,
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>>>>   -static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
>>>> -{
>>>> -    struct vm_area_struct *vma = vmf->vma;
>>>> -    struct drm_gem_object *obj = vma->vm_private_data;
>>>> -    struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>>>> -    loff_t num_pages = obj->size >> PAGE_SHIFT;
>>>> -    pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page 
>>>> offset within VMA */
>>>> -
>>>> -    if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= 
>>>> num_pages))
>>>> -        return;
>>>> -
>>>> -    file_update_time(vma->vm_file);
>>>> - folio_mark_dirty(page_folio(shmem->pages[page_offset]));
>>>> -}
>>>> -
>>>>   static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned 
>>>> int order,
>>>>                    unsigned long pfn)
>>>>   {
>>>> @@ -581,23 +566,16 @@ static vm_fault_t try_insert_pfn(struct 
>>>> vm_fault *vmf, unsigned int order,
>>>>             if (aligned &&
>>>> folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
>>>> -            vm_fault_t ret;
>>>> -
>>>>               pfn &= PMD_MASK >> PAGE_SHIFT;
>>>>   -            /* Unlike PTEs which are automatically upgraded to
>>>> +            /*
>>>> +             * Unlike PTEs which are automatically upgraded to
>>>>                * writeable entries, the PMD upgrades go through
>>>>                * .huge_fault(). Make sure we pass the "write" info
>>>>                * along in that case.
>>>> -             * This also means we have to record the write fault
>>>> -             * here, instead of in .pfn_mkwrite().
>>>>                */
>>>> -            ret = vmf_insert_pfn_pmd(vmf, pfn,
>>>> -                         vmf->flags & FAULT_FLAG_WRITE);
>>>> -            if (ret == VM_FAULT_NOPAGE && (vmf->flags & 
>>>> FAULT_FLAG_WRITE))
>>>> -                drm_gem_shmem_record_mkwrite(vmf);
>>>> -
>>>> -            return ret;
>>>> +            return vmf_insert_pfn_pmd(vmf, pfn,
>>>> +                          vmf->flags & FAULT_FLAG_WRITE);
>>> I believe we can go back to
>>>
>>>             return vmf_insert_pfn_pmd(vmf, pfn, false);
>>>
>>> if the mappings are no longer adjusted to catch write accesses.
>>>
>>>>           }
>>>>   #endif
>>>>       }
>>>> @@ -635,8 +613,15 @@ static vm_fault_t 
>>>> drm_gem_shmem_any_fault(struct vm_fault *vmf, unsigned int ord
>>>>       pfn = page_to_pfn(page);
>>>>         ret = try_insert_pfn(vmf, order, pfn);
>>>> -    if (ret == VM_FAULT_NOPAGE)
>>>> +    if (ret == VM_FAULT_NOPAGE) {
>>>>           folio_mark_accessed(folio);
>>>> +        /*
>>>> +         * Always record write access to the buffer. The natural
>>>> +         * place would be pfn_mkwrite, but this breaks KVM.
>>>> +         */
>>>> +        file_update_time(vma->vm_file);
>>>> +        folio_mark_dirty(folio);
>>> We can be a bit smarter here:
>>>
>>>         /*
>>>          * Always record write access to the buffer if the
>>>          * mapping is writeable. The natural place would be
>>>          * pfn_mkwrite, but this breaks KVM.
>>>          */
>>>         if (vma->vm_flags & VM_WRITE) {
>>>             file_update_time(vma->vm_file);
>>>             folio_mark_dirty(folio);
>>>         }
>>>
>>>> +    }
>>> The rest looks good to me.
>>>
>>> Regards,
>>>
>>> Boris
>>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



