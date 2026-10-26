Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E52E606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=e7bSiCBv
Received: by kanga.kvack.org (Postfix)
	id 31AC36B05B2; Mon, 26 Oct 2026 18:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CBA76B05B9; Mon, 26 Oct 2026 18:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA946B05BA; Mon, 26 Oct 2026 18:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFB6A6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:42:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B76AA7E52
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:42:35 +0000 (UTC)
X-FDA: 85366253070.04.79F3289
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 50911140002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:42:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e7bSiCBv;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793054553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
	b=Bf0dZ0WU6P7Fyec0RU/Ry9tVwr8wQmJ+G9yzApiTDWtFNJShN71lhhgtmCWXIIsY1XRLSZ
	JJ21FJQQ8t/6V/+WNGiSn7Y5E0zkHmMFPzWvZnMt5NYpivjcY8U1avbiXALrEHWHAP05/y
	c/xD/6I6gcyDXJGOCEW4nEQ5umf3kHQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e7bSiCBv;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793054553;
	b=VuPwmy0ZpvkbOsQQ4FI0WfpTI5kjik9kTYtdAFRgQI+mXD/yH/FbQpLbor3uUa7+CVaCx7
	duKesrTTXv52AKgKFIiunMnpuT9HHaISCtFtU5TPKoOFIpaGN9nABgYzq/MxwrmywZOcwT
	b4x03/3iRF2/vpWBuiLVHNLotobygMQ=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c43fbcb4393so495333166b.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793054552; cv=none;
        d=google.com; s=arc-20260327;
        b=SctWFyqqhLr3fjPx6rCDPLSTTDyFdKKSLuLggjRVaO82bq2K+2oz4r+FEs2BJrPdIz
         1de1EJCd/OrbRvDf1dpRu/3y4Pv07OMOGCu+qMb9Cs6FhsbJ54DQ/dwC8u4zRsiSms3M
         3rPgJwBXF2qtQzBEaa0f4kg8olnEdjLf7bzDxvU3h0Q8HpJNKmxo0G0MdJEfgi1VOh31
         v88a0eqJ1HiYftxqHP0C/fr6KbYYkgf2KGeK9giZ9ef5wl4K/m6lJyGtHsfVXBH/cVJ3
         KhnWcUPONdAHO3UvVOkhIayEkUdYrStPrNYcH+XgnifrUlbMw3lYgdk0TYRBRtQ/9YVV
         pR7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
        fh=6xXwOrjdxdwg4Cm3Gty2oXJrqxMcxV0I2q/hSTSsZvI=;
        b=Wli8LkVBot0NeqLCniwTTEqwHwLV1+SHXbDLq+8s/sPKQA/4Aqom6lE2aK5YG92FxZ
         O5XB00fDJn53+MOqhD9a9no+SzRAU6Jt+7L02LHB5sE4/CORjYJnUWec0ppfAive606N
         VFQkWnNGraygsZQC9XtYGOciJwmEcgda9KuAE7HFHxfBan7g7CQoiNmS9C6z78jfNkyW
         zuCqAh5EyZQqsw6UXCs99Pt3CjMjtKgII8pFaAA51l+4MCrpu0H1QRjhCNmRpn4CECT9
         ZzZzO/Q+o60cCXt8Fly3XfMchcgF0R1XcRJxVm1FEDM3Lvp0SsUbdIezRFCIWEaagukU
         RGGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793054552; x=1793659352; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
        b=e7bSiCBvMn5mJ+gSUnln1QGGZjNqr1L7q4eFUQ5nGjkJXbSwHMUuz/H6XkaKRMU9or
         xgCP6q57el1slgq+h/G9AkneEr0ZJ3uSNgf60AhujqCppHSl7IhywnmIzU/KWBd3UwEf
         8216yvGxyH82mRrd2B9Lnv+kfbJD3Cr6SVAqGgw9bxTjgoO1wyzTR+/jK4brPgsn+2QG
         N3wmkGl+p87uI3UmQRfvFg5FBPXcTOJ6+CQnwkh6mUikUFjpdK4kg/OATDrTTa2IQscA
         RrTZ8ZqMeMxooiOG/gRuUxAiUcirtQxsDWwLWHtWv3soAc4SP6aKP5qhvz455+guBtnt
         PK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793054552; x=1793659352;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
        b=K8auTVl+hmzzynI0sCh9+Q7ksPtK7/9mGRlfsPKNhfbioWdLHT6QIm/sll+aRb+nme
         I1BpHYrOxFuveRpwjZ7LAuQb6qPc9NvSsNC+3V8evZwDJDU6AiJ6KG7IUuAgq/EkS75v
         iNPQK4mUiR/SrtY360f4RJduDaImr/KFASz8+qvBui8L/XGRc5mX/WNiDgLVDcK+Z7Jf
         KUY1GKzqlR7rG1i5KG45kfeR+7N+Q/8Cu9zy3Badai+X41M5cIAhxC4/iegmWcT7TBPx
         h2hIzOe2bDBadIiG1StkQlfjjttuJEtsTHKLUI44HvwsYm24OMP6y2rcHfDxAV33mvZr
         Oayg==
X-Forwarded-Encrypted: i=1; AKwUvBzcsxiCdb4UlORqGcwGsgBZiB5lhm+tqpUywsX/cuvtNJDcCUPVxFoOBGjs8WOd3bUf+NIhDxkyDQ==@kvack.org
X-Gm-Message-State: AFq9FYJuw6LQTkWbnWPDc2HYB+cbbeE2iQxcqEtkX1wL1IiTy5nxSbXc
	j661w67AtuA2w9V4T8x+FBcXga6NXYjMl2sfyKMOeU+SmT36ghzKuaZCsJLiA8e9DldVtBS/ej4
	UuZPbzBNkJp/ddXZ/ejY5NOqmcW2WVcykDb2iBJMH
X-Gm-Gg: AYBFou1Q+az6nHYNiTDPi3dBm1Snr4F8RjxI+Mr/p9JeXf6YHA+6Y9y2dV4nGruyTm+
	8HQ3XHsWfo69irF8sr+6eGu77+m9IIwpmXMTSD4EPPih9iuf6NMWFJsjAtDJAIP1ZspMTUhiDea
	3ZcZ4P4uNEtdjG9MBMMB9mptyYjlyPOi//b1tLUzATRvFcXt8xoyyOEyEzu81TWcXtS8DqFU/Qr
	Ie7R0tfk9etm/GCIXschntsKhqUh+RxjA9cIAhBnYvC1IdFSo5bL7ApCxcnV0SjRCRxZCRM9vCh
	VLu+rVrgcvPglSE6QroLxmwZRjhTlYfCYsGGmVndj1WlOx3Y3t/vqcUHW6AjnmsEl13L2bph+gZ
	a9W28R/8PMPqYYgrbgUm/dsRO6UO5T0yfzN/4dnWj7O0/I3HsHKMtsYgGeGtWMCiPsHl7yXT9uO
	Ws3einnZR4Go4Y5TGSZAyW+oen+8QibtQNFNm/Iaayrbh8QTXougGKr8ePc2azdKadwBtwEN9iH
	4FYS2QI
X-Received: by 2002:a17:906:4fcb:b0:c46:8733:642b with SMTP id
 a640c23a62f3a-c46bdeba20dmr991156866b.43.1793054551213; Mon, 26 Oct 2026
 15:42:31 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026215226.3713941-9-jthoughton@google.com> <da7bb91d95914febc9b2b981c0b8292022d6f6437ecb68ed2b717f0f4a3a04c2@mail.kernel.org>
In-Reply-To: <da7bb91d95914febc9b2b981c0b8292022d6f6437ecb68ed2b717f0f4a3a04c2@mail.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Mon, 26 Oct 2026 15:41:52 -0700
X-Gm-Features: AclHuK9NQf_DmtP280VFWB18VLK39ZMzdxZm9Qsh_-4Snm7U1eOCkiznChHcSHY
Message-ID: <CADrL8HXA3KVX9agtcExpPuaBLC-zAEWx6QgsRnQ6+cb4AZZrFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 08/10] uaccess: Refuse and warn on __copy_from_user_inatomic()
 without an mm
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, tglx@kernel.org, 
	peterz@infradead.org, kees@kernel.org, arnd@arndb.de, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, seanjc@google.com, pbonzini@redhat.com, 
	jmattson@google.com, axboe@kernel.dk, asml.silence@gmail.com, 
	James.Bottomley@hansenpartnership.com, mkp@kernel.org, dsterba@suse.com, 
	mason@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	john.fastabend@gmail.com, jpoimboe@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, andrii@kernel.org, martin.lau@kernel.org, 
	eddyz87@gmail.com, yonghong.song@linux.dev, ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50911140002
X-Stat-Signature: 44hns9n7da3wm9i7kqgfycnd97m9w6wc
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793054553-300088
X-HE-Meta: U2FsdGVkX1/ELSGxxZiNd0Cq5+JTjApfBhwwW/HLMvIRoS1GAgHL2kDFG/HvQUd854RdXezEwzMJSaj8fG/J0Xhkkiaa6mevqKR2ot+QNas4AGE/FaEmjWeycoTtnZoAjhX6+MTO9zQPv7ZlRsB+MdJSR9qxeHAiyPXPCCj6qlBxxSPEFb0+JmgIBwM37Y6S8Nh17AwOKJQ4iY6C2gDYrNxGZ7jAk5pyMI+9US6rSt/LdW2DjmTu17E9+Njy/0wpiNEXM4ZSf5LvPShCKROEXVTT024cnpsRDARrj8Y4V30BWMkaR71m2oNioKti0Tms78uySZGQL2421M6+7rMfNkU29gYToT6aJpp6Gm42rWvCTumO2TXMibPivvPJhnPIWTw8/8UCzbKHimB4y0ZGom2J1VooXa1ZlpeAw7moJLWKrXX+3z5e5uILu5SU7V0ZsT93oDnAytS5zQoDFq/OxCThL71dB4lBvRdZypWZIBj/2xjWsvqnTBpWS9aPcBMBsJaLDDbYoFmTBDqMs5xI7heCeB4Cc3ZsePva2TLAsVodYxylfkfD6AZ07jb1toGmYMBhwfIhW1Dh2fqmF0/7NaQaVlubEuOw43Aa2luYg4PW+5NCuF63K3hV6CIjQ6jSH+SYUwMPD3o7Fl7G9FlWySJu/KLyqTD3zBShMG0oqic+otDKuEpmtkr6cwlvq0BU+pcKpAgUwpSqvYfxwklOOnXGH/JLEDAZLCXqZ88Ly1S9aAL3MnFaZ4zXDHFuBmMVBWF4C6jF1s073uEqgUj17mVX71IO0r3BcZi6YXoB1T7Wx0sv21CmKuasKaoDiNcxRyBl/CaidumPcxynDa4DJtUhqV5HwKrxKC+aiz+rGAGXBeAIhkUzwjGQYFWzMmYb+7KpbBwsqCPZDSaAPxauZsLHgF2Xn7O5ySacamzVjAu2QnyAEhiiOTeVlmIKsL97ee2GjDXtGDL1P9qTjMr
 r71ywHDR
 kugWbyXZnIJumV3luLOg/FkaUQj2uIpwmScJr1QaZ9oiVIvuzQks/FNUNflMmH9Z+h80GxF8Y3dGub49uh3zCd9P2ayNkNQbbLwu7qrjUwywemmFc48GJ+JFzdkVB75foVefk4xjtklhQnr7BstiDN9iQ7AlUhi2jHqIMe+hpD2jBKZY05RSCqy/zDFzVcp7GJKkj5Gla4C0+f+3fi3RzUr1s8h2okXNP3MgkPAQK1r2dQCJJ/K2YtD2rrK795jIDDFvBbCsDaLeg00YsPSdBVQL8GSfvuBDPadZup9FIOy7mdGbOA8n10eizFxhxYfwcTtRzy+g1C8+uAC1Fl3DXfSavefs6py7wNE3CBBbXUxeJlkIYodLrtiTykWoXNXnQnB4464Ff7UcJ0mpT+re6yhMWw3OHKcAu+IZTdYbB+gQQn4LF6yvmqz4FaGnC0rvD5Iu1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 3:30=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm
>
> TL;DR: Commit message only: it names kvm_read_guest_atomic(), which no lo=
nger
> exists in this tree; the review suggests kvm_vcpu_read_guest_atomic() ins=
tead.
>
> >     uaccess: Refuse and warn on __copy_from_user_inatomic() without an =
mm
> >
> >     __copy_from_user_inatomic() never called should_fail_usercopy(), so=
 the
> >     NULL current->mm check added to uaccess_should_fail() does not cove=
r it.
> >     It is used e.g. by KVM's kvm_read_guest_atomic(), by several
> >     architectures' perf callchain and stack trace code, and by the gene=
ric
> >     copy_from_user_inatomic_nontemporal().
> >
> >     Split the NULL mm check out of uaccess_should_fail() into
> >     uaccess_without_mm(), and use it in __copy_from_user_inatomic() to =
warn
> >     and refuse the copy.
> >
> >     Don't use uaccess_should_fail() there, as that would also start inj=
ecting
> >     failures into __copy_from_user_inatomic(), which some callers don't
> >     expect to fail in practice, e.g. __wp_page_copy_user() warns if the=
 copy
> >     fails twice.
> >
> >     copy_from_user_nofault() already fails quietly when current->mm is =
NULL,
> >     and the generic user stack unwinding entry points (perf_callchain()=
,
> >     get_perf_callchain() and stack_trace_save_user()) only unwind the u=
ser
> >     stack of a user task with an mm, so neither is affected.
> >
> >     Signed-off-by: James Houghton <jthoughton@google.com>
>
> The changelog names kvm_read_guest_atomic() as a user of
> __copy_from_user_inatomic(), but that function no longer exists in this t=
ree.
> It was removed by commit ef82eddc0e31 ("KVM: Remove kvm_read_guest_atomic=
()").
>
> The KVM user is now kvm_vcpu_read_guest_atomic() in virt/kvm/kvm_main.c,
> which calls the static __kvm_read_guest_atomic():
>
>     static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_=
t gfn,
>                                        void *data, int offset, unsigned l=
ong len)
>     {
>         ...
>         pagefault_disable();
>         r =3D __copy_from_user_inatomic(data, (void __user *)addr + offse=
t, len);
>         pagefault_enable();
>
> A grep for kvm_read_guest_atomic only finds __kvm_read_guest_atomic() and
> kvm_vcpu_read_guest_atomic().
>
> Could the changelog say kvm_vcpu_read_guest_atomic() instead?

Yes, that is correct. I've applied this fix in v2.

