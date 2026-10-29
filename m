Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E64606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BIqB4iqJ
Received: by kanga.kvack.org (Postfix)
	id 399D66B0606; Thu, 29 Oct 2026 12:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A116B0607; Thu, 29 Oct 2026 12:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2399F6B0612; Thu, 29 Oct 2026 12:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED7406B0606
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:55:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F915A7FF3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:55:36 +0000 (UTC)
X-FDA: 85376265072.16.F04C50D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0405F1C0010
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:55:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BIqB4iqJ;
	spf=pass (imf21.hostedemail.com: domain of slopezpa@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=slopezpa@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793292934;
	b=CIz16LO+yz0MsagHuvAprt6YaY5VuBC4E/LT/PUa/DRVvVy6Mxhvu6R/aPlS5LWImGCD/h
	dPgNOles2sk2ZBHuWWwagDd5sbfWVf21Yoxr3WNRSotkXFgPBvFaR3cdJqYYy1cXYgp/Ku
	qBbEaOyFaHNd5fC8QUxQqoyI0QZKQac=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BIqB4iqJ;
	spf=pass (imf21.hostedemail.com: domain of slopezpa@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=slopezpa@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793292934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXB64NJFF4WXwJ9sa1LPJLwRXbNGHs0rY5npnlz1t+E=;
	b=utE1OkofyhHBMj8M4K5j38EcYNB8KOousl1kz37AGLZtfXt4yrJfw4QBctBnGwztCmwzPD
	5TYoEMt1hJnSmPVSsmDW6IQHZJtasQ9pV2teJ87d9I/64bRa1veF7t7lS5U2ntU4ukfFR6
	MExGN6aQs7j2xdLyD2MRaTAiCCCb1gQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793292933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TXB64NJFF4WXwJ9sa1LPJLwRXbNGHs0rY5npnlz1t+E=;
	b=BIqB4iqJYB6wXKgk/oL6rLE+sigxUkEmxQwA9AxG+lOF5Plh9uxCiPLcOnACoI1skni45g
	rckI681IGcgFjmi6Cm6MHdYUNZY6rTe3FcOK+RdWCQ38EjDK8ETT3GciC6TysQyPHS5E9j
	H0QRwUUUPeHPo+/o9zsR2R72fh/HYsI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-qAshvKzBN1yfi7oAtLEyGA-1; Thu, 29 Oct 2026 12:55:30 -0400
X-MC-Unique: qAshvKzBN1yfi7oAtLEyGA-1
X-Mimecast-MFC-AGG-ID: qAshvKzBN1yfi7oAtLEyGA_1793292929
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f32050e72so555983585a.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793292929; x=1793897729;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TXB64NJFF4WXwJ9sa1LPJLwRXbNGHs0rY5npnlz1t+E=;
        b=GtHFYMb5FahsRML3sKWTPf5B7N7ME8pmO/d6vFTcYmVmHfmP6p2G8wteetH5lt/gEO
         t+7Vk7tZ8aMwJ3IWHrPKTDypDy8E1RNZE81joeRd44CIqKansK6vDpciGEGsg+2vZuj8
         Kuxa+Y5c1wf8PQ4OJq/o8G8je70W27s/yj4uHK9QE9Z0VURRp7VYNKtvtOPo6JQUB7jm
         rGUPbDKPdo2KB4p9gSFb9zSR7zgIuLQ5eS6V29uVQzEXMLXgRzSVURpuKZKiYJctcAmr
         sAum+OXgPmodI+XxoKY8rqUs9gwOOCKzn2trmKsEvJBaphjaGipsPAONnX6ZsWzt4V3w
         QSuQ==
X-Forwarded-Encrypted: i=1; AKwUvByPdEYCam4L0cOqgxn48gqzjIkiVAtXPDMFG2N/mKBsZtwCcTmXnqMUh4LPfkGgC8yu930R4gcL2Q==@kvack.org
X-Gm-Message-State: AFq9FYI5ufU537tHydlFKR0+w21rDQX3DLFh7ZQv3zFFAMiuxBwjbd5j
	kZVAB/YNjU06iHG1ScO6gmzz4blk/dpCNiLgJOXqLj5OM1kFXNNSKeVs5EmVQw5igLYAgwZ271z
	muCU8+nS6tMQWvd80mMW8R6LgR6vH6+wYdo4IK9Os2li7vHexzIuJ4veNH5nv1kaExQaNvPHga1
	XbkFQBBom3/pCoxNdKHwBuMk4Rkc4=
X-Gm-Gg: AYBFou3syclLoRLhbxS9uBHDx3HcSxnBf9O8ZlMbxzCXGjstT1c3JD1KZI2wY5L6n9T
	mz1Zc0IrNWwJEbuS3Be6m9vMS3po+Z4KMRJ3vgYUD3R4HH1hNV3MvF1Nz2A/LK6CchpFKuUnlZL
	J/Lz+1t10UuRTRsabxp9V2XAtDcb2lmTkS1ywE8YPU8W7//diAZgzErCE=
X-Received: by 2002:a05:620a:1a27:b0:93b:ef24:bc8c with SMTP id af79cd13be357-94408cde203mr957070785a.47.1793292929327;
        Thu, 29 Oct 2026 09:55:29 -0700 (PDT)
X-Received: by 2002:a05:620a:1a27:b0:93b:ef24:bc8c with SMTP id
 af79cd13be357-94408cde203mr957065685a.47.1793292928789; Thu, 29 Oct 2026
 09:55:28 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 29 Oct 2026 09:55:28 -0700
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 29 Oct 2026 09:55:28 -0700
From: Sergio Lopez Pascual <slp@redhat.com>
In-Reply-To: <18f0bae1-5cdb-460c-a147-33cd1fa2acdf@leemhuis.info>
References: <20260804140403.16337-1-kfastov@gmail.com> <20260804162924.0268f80a@fedora-21.home>
 <CABWhNekebS6dt=Ft+74iG4YpCq-5ZcV1EvvERNxT612VUOC9Ww@mail.gmail.com> <18f0bae1-5cdb-460c-a147-33cd1fa2acdf@leemhuis.info>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 29 Oct 2026 09:55:28 -0700
X-Gm-Features: AclHuK-xgAN_fR_dbuTYNWejWEVdFE5MAwn_KoUGHzvKxdpt-_9FR1Wg7w13_Us
Message-ID: <CAAiTLFXd=LK93e=f3PE1f6y5m15yVknqqVNBei5rLz2AnSJ4pQ@mail.gmail.com>
Subject: Re: [PATCH] drm/gem-shmem: Install writable PTEs for write faults
To: Thorsten Leemhuis <regressions@leemhuis.info>, Konstantin Fastov <kfastov@gmail.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev, 
	stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _RYe7HWbyTMgf5mgb5_Dc8WCm3XAXOdrMpD4bGKOk_k_1793292929
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0405F1C0010
X-Stat-Signature: 8ecmg9z7a4z3whrbwns89sskowatocic
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793292933-470689
X-HE-Meta: U2FsdGVkX1+y7vjthg5Nq6dTESWWRikA/+yELmyG6hxEbwYaemvodEFhiZYMb3CMEjpMQs6HrdHfHFBqPt2ppQqBfgYobbcjZaf1RBPBf/ibLRepUw8W3sayhyckHTwlnFRRT7vso8nI/PeSB4P9iLp57hwpLbHOsa2FiZjLihiW8xKeYdG2lIVpNujjoVpM0o/lYyGeeUSWrD0N17i7uWC3oRqIPW62nH/k0SlrwlOjtDKc+vQWBCUVP3Wu9J0fS7gYfOKWx56In+Zx6zYl+dm8CZfDLrndnRSJWCYTJlG/63bKqQd1aAnA7xS2+ZnuzIEaVKQB6pdMm7Gr3JRi/sXNnxps9yr0HRxv6q+ZRL4MDX/eK7dUC+RDGXHlgn5Qv371ac7uOsTnkAQaBgXzqj3mpDNJvc+hIxFGBhchlSccpovLb0B8WR3nyR0psQc6XhAUssJ8xQ0d5Tub1Nm31+o7NbtuyviFzewqbbux6xyvdEyBLuSdLXEel8hkb6cRGH6aMr9WPAdGTaSl1dcIUl6RYL7BNXXnmM0QB8NUDW/EaiP7OyaPidgkejXNtUQ1po5w284jtqGrrBdH7MPPXj7XtCoPvgkmlK8Ztz350LFuKXl+1w5E2wbonYZI4PF9qkuJVP+jSJCChNEwSjv881oy6WSmUek+Jbx+py71CUWucEwwabepdjolV40PuwOf4W5ZdAC6RbizczEG7Yk+CFVFxLUIHibviCCBwsdm3gytNq7caYVyk8LA2w168VY7zDeWFLRoR3s4xNcXf/gz6Mnft62He7dq2NIW4BOJJQcwONiOp0IMY3EfuTmifE6Wa4RKV9AupTemL/N6J+L2WsG4jrV81D7ZjLwUrlhnZm+hSSIhdv8JrZMzGsc4FoqeKd0l0MBpTgQd55KNa7c7cPhJeQ9z5+enTPZjMqbU1u0lOBxTRAaU0tTmqYwvR1vxBmuS2yEAMQQaWU6XK8R
 Rbsk2K/Y
 5CgintD26g5HJhN+evCP5MqcWV4KNw/Zw3tCbWl3v3BjQ6ZbCetQ85Y+5Vu9+2s0fXd7Z3aaaVYlR6WALjxHKODDAcugswVNM4TP3NFzQeoVfazsWsHNkPZ9mmY0+tMrOMt5ZSuvsq1TPyeAy83RdqGnHb3LhBUUyBUOgWna6qmQaM4G3J4bBUoV/TYs/oee9dJOeCj9Uduu0ba0wLepafoljPM1798SAoHNKbH4eSidDn+QAq+9gBWh/wNgqn0+dDU+p/4RTF0wXWsBsim07j95sq1lC7/lmfCxViS+Z/lVRx4gXbw/VVjOu0vGKa4MIonPkj93/H5SVus7fcPNj5rjz8jfyBwxTGZTi0Wtd3zxltWCDE8kYtBxFoqZwCGE7pF7/NW+qhNHTFJqipTexftJn1ZXlRnDFe7NAmL0pddqfaQEZKY0TAdKNb4LbVb3J6sDo6EO/ZsgSFT1fqFovXzPeLhYMrF2IAI7krsyyFtXYmrL+uDBKsuZDn7USQZHioQqBxuTsMZp72DI1XA2v4JGgYHUcOfh6TWB9xqrucUfTT3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thorsten Leemhuis <regressions@leemhuis.info> writes:

> [CCing Paolo and Sergio]
>
> On 8/4/26 16:57, Konstantin Fastov wrote:
>> =D0=B2=D1=82, 4 =D0=B0=D0=B2=D0=B3. 2026=E2=80=AF=D0=B3. =D0=B2 17:29, B=
oris Brezillon <boris.brezillon@collabora.com>:
>>> On Tue,  4 Aug 2026 17:04:03 +0300
>>> Konstantin Fastov <kfastov@gmail.com> wrote:
>>>
>>>> Since the introduction of dirty tracking, drm_gem_shmem_vm_ops has a
>>>> .pfn_mkwrite handler.  Its presence makes vma_wants_writenotify() true=
,
>>>> so vma_set_page_prot() removes the write bit from vm_page_prot of
>>>> shared mappings, and the vmf_insert_pfn() call in the fault handler no=
w
>>>> installs read-only PTEs even when serving a write fault.
>>>>
>>>> For regular CPU accesses this is transparent: the retried access fault=
s
>>>> again on the present read-only PTE, goes through wp_pfn_shared() into
>>>> .pfn_mkwrite() and the PTE is upgraded to writable.  But consumers tha=
t
>>>> resolve faults through fixup_user_fault() + follow_pfnmap_start()
>>>> perform no such retry.  In particular KVM's hva_to_pfn_remapped(),
>>>> after "successfully" handling a write fault, finds a present read-only
>>>> PTE, treats it as KVM_PFN_ERR_RO_FAULT and fails the vcpu run with
>>>> EFAULT.  Observed as AsahiLinux/linux#560: muvm/libkrun microVMs
>>>> mapping virtio-gpu blob resources die with EFAULT on first GPU access.
>>>> The traced failing sequence: [...]
>>>
>>> The same issue is being discussed here [1].
>>> [...]
>>> [1]https://lore.kernel.org/dri-devel/20260804120529.1730187-1-pbonzini@=
redhat.com/
>>
>> Thanks, I missed that series, I searched dri-devel but not the kvm list.
>> Paolo's patches 1-2 are indeed the same fix (down to the same function
>> name), so please consider my patch superseded by his series. [...]
> FWIW, it seems that series takes a while to get polished and mainlined:
> https://lore.kernel.org/all/CABgObfYgZ87%3DW%2B6E%3DN%3DWwTuyYkaoKU3hqd84=
JDTSAvT3_9dh6w@mail.gmail.com/
>
> To quote: "It ballooned a bit and getting acks from everyone involved is
> hard... Either I or Sergio will get back to it."
>
> Is that something you/AsahiLinux/the world can live with?

Asahi still ships their own kernel with downstream patches, and have
backported Paolo's series. But for the rest of the world this is pretty
bad, as it means anything that requires virtio-gpu with blob mappings
(venus, native context, etc..) is broken.

Since the proper fix is going to take a while, I think having some form
of interim solution could be a good idea.


