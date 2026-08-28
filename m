Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFABC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B87C6B0088; Fri, 28 Aug 2026 09:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B5B6B008C; Fri, 28 Aug 2026 09:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0985A6B0096; Fri, 28 Aug 2026 09:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C15516B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:21:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 404E51A0349
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:21:19 +0000 (UTC)
X-FDA: 85150739478.11.C26B0AF
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4EFAE120006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:21:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fo2clVPd;
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787923277;
	b=rRT/SRvnqexSORdC+2sIC/LGZX5x477IxMyPk0q/rsTnVZM8vbvEs9fCwk5xI3gkFAjD5q
	cMbqnP1GOMrzusuviC0UFckd4U6Uxm2Z7JtwORZHQl2LtA+wsva0SftDiaiKcuKy9zcuKv
	gRNsY3pIQ7NqmsBANNBMeX/eUJ66SG4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fo2clVPd;
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787923277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmuJ8XeoPh26H2sa3OfduzNJbG5iPyqGukTAzRwDvaw=;
	b=qbkFDAJcjxbKQwd3+rSZ6jZvdWX8j5HG+bYbQ6dmyeWCDiz/Q4cpeDTeYqbFSzSuDtaE0d
	sl6RwIDzA/iY32UYtl6Ex/8GGgi24pQB0ykzt7FsEKWpTkRZXHZZdzW6+OIOi1p/vJbYEP
	PP13xkf5J2tnrtisMHrzvEjOLAt6MQY=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cede6375caso116825ad.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:21:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787923276; cv=none;
        d=google.com; s=arc-20260327;
        b=ZYpUowKZAQW0sNuBS6LS0zPnnFsZ+4mr+EsQU3A98e2Jse4fvPhtzjrf2Dh5p+Jjko
         X1dv6MIM5Sm7RzcDpnECyjS/OIvMkpYZT1AaFisTQMATdG+2b1yH69bSlfb5zIV0sia5
         naROsFUYdE6NZRPg7yJXn2e4HLNzEBSUphB0mRYaAU5nZH24CXYR56jC5Ap2PWG0/1Rw
         JZyMrKXS4PLyC5skQbWVnegTe4UyZj2lOV1pm/O9QYJ95Uk2RjFRmTHQGhjVjxLXQVsh
         xNhbMVBQ+Fb56o5ngHoDmt9HRImS68oJVmKRAEQj+tf0TDIyjexWlYj9JPJEdfKoRCbb
         E46w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TmuJ8XeoPh26H2sa3OfduzNJbG5iPyqGukTAzRwDvaw=;
        fh=uw3q1DITyDXkiNskV+FM3z+gW0+1dR1Z8WEev3EHtHw=;
        b=lhG+FlQ8pDIrLtf4mrtb0C3dS8KJbjHYa1arMutbBtiwIyGbAE5SDgp55aZedQCTGP
         zIpedwfrwTA5uE0r3pf7iYIBJUGtGAqLznBysLLtxsgXllmERSJ15ZD3tWNe/r8Zry8F
         KK8y3zdb8rgUoxphNzFuv8irZpMNy0FyYiamHS4DxsXND/2Y31qqcNGJmmKKWwKYrBMW
         naEM1qEprwtmSYJxM0X+7dQ06LZEzwFsCl3jDBjxMgB0xwuSHV2jl5c0RP5gVOySQX83
         VHC1XznXQVpn0BorBuY7QSg10b5APf9a0PCMENqv2uTG5ld+xzfXghvHBPUZVTu6/6XL
         NLdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787923276; x=1788528076; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TmuJ8XeoPh26H2sa3OfduzNJbG5iPyqGukTAzRwDvaw=;
        b=Fo2clVPdUax8SI6sdfrPx/FW1y5GYMflPxGjNbN6Kb1wvjjnzuUZ17rlWaX0V+NKGe
         wAZU9bBCTtiQ9HBTHnngP2/tkcC3wYq2rdFZQ2fh6hC2uXnR6ScMy6J1J0c5MBxkB1Nl
         4aM+84iBa2MZjv4VAe8nNbhmnUpCTdyELsHAa6onqsv87pWic+Welb44ZWGkQQXFnfva
         NZ0s7+ORF/NWj+nfHDyarCcPllZWqLtryno9rWRcQ7QWE00VjXhzHyJEqlgcB0DOzUQd
         YZxGbby3fk6Y5UPrWdW6IBSM2lgj7z5ESsQIPyDKfheJC+QYOfcq4DUnQQluVVgHi/l2
         TMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787923276; x=1788528076;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TmuJ8XeoPh26H2sa3OfduzNJbG5iPyqGukTAzRwDvaw=;
        b=eYebc11VvQoJDAl0Y/gycXjJ73hhJ83dCEb2vK0fRKIoYTNupGFdcBsJxz92RWhBzo
         tW2r6ZjHnIwK7Fkx2bfF47CUtEv0CzjlvWFxrQLFO4GTh9kPFtXxX8ZfvvRj1Fqe0msP
         BUp9WhMMvXgOGnPHD156iB1nOWHAB7N6jwZDTcJfRxR4FhzMSXq4uCXm62dQQ7mQsOX5
         TPP4qWEdh7CVFSY14UdnBNr9Xdahn52iNQ52gOU949Z7yKUy6FewXfYI6ZLKj5yaaepc
         +mtfUoFc0JW02EM7MPqeC+WE0ZQ5ilZzSKCWlFMo85GrDSaIby+/gbPSJDyWFfuFC7GI
         pFow==
X-Forwarded-Encrypted: i=1; AHgh+Rrzc5+wPzewYW1tTNidfC8ke3G0gfMxpu6J++0/kqK6h24zN09ug+E1ovg9ME06AEjJLQwNOW5uHg==@kvack.org
X-Gm-Message-State: AFuF++nfzflNabt2ASAf/rPajCLf3p8T9JOLfCuYRfiNMWO6+w3dxFJa
	RmhiA4myg4RMq09trIc8bSBuSQvkNdpLmFqPdjF/tUjL2jDiPjx258fyd2rnAh88l3tvXevgv3+
	oDSbpyMlm3UQvsLwbuj+eeaIO5nXmpMOTo1pTANgh
X-Gm-Gg: AR+sD13LIEAsPwDHeVvJcJghwy8cp2VjrLY/O9cJBDNxUqzmPcWgLqMNor4Nz7QLP3o
	uPnBmoNwMK4bev5IHj/MsbzC7AuW+m33qTSVinYg111NawwG1EHEIFQu7gYEHwupIHaGPEj906+
	jCyUbEU3a9iJ96Hn93HpGRBMnyLNPbmfgdyj1Wak8fbn4XW7UerjsFm5OQsqZegYTr+EvhJQAHI
	tA1eY8eMtvBmu8yLwTJFSP68CsSH+lMhJZfgdPr98FZbMK590GQppzpCTbOQBIjWbH2zGMzIxrB
	DOWMg6/1oZeco8fRvgky7Y6zFYhNWHSx/z8KY6CqYlTLyOAVxpu9z1g/8DS1EvsWOkwITGGD2Lr
	e8fnAzqhS8OVJQmmg+sUDMKoMYjHRfA==
X-Received: by 2002:a17:903:b48:b0:2c9:bd54:cf with SMTP id
 d9443c01a7336-2d74f403213mr6682285ad.4.1787923275276; Fri, 28 Aug 2026
 06:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
 <82929c994076d95f99560ecc67f6cfce@paul-moore.com> <CAG48ez1rd3cFhmGn7mWkaVvGqYg+cDiGUhuhH6r51dUm-QBXUA@mail.gmail.com>
In-Reply-To: <CAG48ez1rd3cFhmGn7mWkaVvGqYg+cDiGUhuhH6r51dUm-QBXUA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 28 Aug 2026 15:20:37 +0200
X-Gm-Features: AcwNN1X1_-cZAxs-C_zVg9dDOHf5DCa4yCAEiND1xrtOkQ0sGqfzpyFhp0b8haE
Message-ID: <CAG48ez2jgJHewZYK1SVccJmBa=bjoMW80SPNcbgW2XCtZaWhjg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4EFAE120006
X-Stat-Signature: nygz4d67jcjk6azp3zp4p1u4btk6z9nd
X-HE-Tag: 1787923277-195465
X-HE-Meta: U2FsdGVkX1++43CsSCc1ooZZTqN9XPDPiVpC+T+ti1XQpvsYo1394N0KcqPV+Yuxu23HHMcgixYy8ryGAkB+k1kEIsN6JsPQzYaBJIWjA7l5vtAGHS4e2nTPxqIdgIieSfr2Iv3FURPL+dX8G3vNdXi77e4UBUkN7ZuR7OIeiHV/dnmPdeq6QV6MTwWS5smXla4C5tU0xd7tmlEM+uNBbYJQZqboFTPC6GIs55yeSa+W9Ndl6rqcBCh9Z2l1vIYmMpxMzFeKvdcbhmK9cvuf+EYoxSn4pU212Vl97mE0L8NgODqAtXHzPE/KGdiMLgY4gTLIRVUO9WASM0qay2t7Q1fpGsoTWiq8Yplefdb1cEujdfK4+63EIbCrqO8oN8afywVpj5pR+LdqS4yElSBAq4LlxKHPYvyfptUE3yhFBVXfJG6JCnHGccrOS9Hi9FLmfB7aHol7dWQKHHkq26DPLttL7OtdFeOKr/OvWO8Kl372cD2Amug3FdxEaB9pcxhy2+AMSp5R7FhO5LP/cY7yvaPql8phH3wtbvDqWyXgDooVbZNGPuo4JhT2EWkwqeweJrRHreqAdG6DEQcXG9FYmtnyBqvxo9NgGWNAJx0W7wobr9JDrtJxmEMi2B7VaoKlh8HlDVHGN72Bkfjk/c4bQ1Z3i7oVHEaXsJBhprQL9rXaLuEX6tveCJe+x8sOZOFyKhXyqCqr5QdjcwthoxhflAkJTjYonKlCrT7kD/FmS9w0j3VVx5mwztMBINFNJxsRF2LYSiEtYgnMD7+w3MTuPOgbiN9OYjfHt5aJQdkCQwGiQfyA1rjTYx96fw2tIzf9EZZ6u6NKpGz7e8fTLY1YAbsNSlE6Q1SF2rhLVNqfHA7JtBCopLhG03KkFamZiugdosluO9t4/eyTk4dtW/znXvEyyWgCGnE4gUxVj10a1ntwf/m2EP3+en3HJm3ovmL2UgsqUgBKZi0lI9T4p8I
 NDLknK/M
 vNfsWXQJM8OTycRV198PVXWpCyZP+uxJRwOVbXGnire8Un+y3Ubt3kg4/z/rqgFEC4aMc4hPrWUiJ+7/6Ow+c5zI5H/kC6/oyySwc2XskGfdFSp0IaFwB+ViAWjSDpenLQ8WovoWCqZLtUrcZAO//Ox5q8uLqLJ926/3+bmGTlM5v/e4gWGkpkfjdxw0xK7uS3k5HCt7qz7KkQA44b0minEftmfPJfxI0WkUI8HDIlTv1ykdUS0bM/ry/xUJsZGTdOmMCAkm9wMl+xmuhA/fTmrZ32KgDCIIhpftOTZSrCuUgPxU70t7OJgAMY2awMI0+RLS/ixhgaX/TicJbWJ41V/+MqX6hizec4Q97RQxqBOjwJGeyukxNenCeKUQjBSAJWYzJYlrCcnNG2uuL/PbZsvkP2zSJOEH4+BFsnzd8di2toeLQ+omLPAtj0dGCGjxv3V+k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 3:03=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> On Fri, Aug 28, 2026 at 3:10=E2=80=AFAM Paul Moore <paul@paul-moore.com> =
wrote:
> > Beyond that, we really try to avoid making LSM hook calls conditional. =
 It
> > can limit what an LSM can enforce, it tends to be a bit more fragile, a=
nd
> > it adds some unnecessary work in the case where CONFIG_SECURITY is
> > disabled.  I would suggest passing 'opened_by_owner' flag as a second
> > parameter to the LSM hook and calling the hook unconditionally in the
> > default switch case as a replacement for the 'return true;' statement. =
 I
> > understand it may seem a bit odd, but we try to make the LSM interface =
as
> > generic as possible with respect to different models and this is one wa=
y
>
> I guess I can do that, but then the question becomes, what other modes
> of using the LSM hook that don't currently exist in the kernel should
> I be supporting with this? I can make this a parameter, but any LSM
> policy that actually uses the parameter in a different way would
> probably be buggy/inconsistent, unless other new LSM hooks are added.
>
> If your intent is to make the hook work for any /proc/$pid/mem access,
> including when the caller is ptrace-attached, then I guess I have to
> move around the security hook call in proc_mem_foll_force() a little
> bit. I guess I'll do that in v3, though I really don't like trying to
> come up with a reasonable in-kernel API contract for a scenario that
> currently has zero users.

I started thinking about how to implement this, and an annoying aspect
about this is:

Currently, I only have to look at the credentials of the opener of the
file - that is both the subject and object of the access. But if I
want to provide a hook that works for any /proc/$pid/mem access, and
want the hook to know what the object of the access is, and do it
race-free, then I would need to grab the creds of the target task in
mm_access(), bubble them up into proc_mem_open() and mem_open() (which
will require touching all the callers of mm_access() and
proc_mem_open()), store them into mem_private there, then let
proc_mem_foll_force() extract the creds from there. All that would be
unused code.

Do you think I should just not provide credentials for the target, and
document "if opened_by_owner is true, the subject credentials are also
the object credentials; if opened_by_owner is false, you don't get to
know what the object is"?

