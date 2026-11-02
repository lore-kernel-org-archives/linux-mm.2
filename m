Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D428F60D5465
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z4IgsNSn
Received: by kanga.kvack.org (Postfix)
	id F0F3A6B062F; Mon,  2 Nov 2026 10:31:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC00A6B0630; Mon,  2 Nov 2026 10:31:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD036B0631; Mon,  2 Nov 2026 10:31:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C897C6B062F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:31:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65F97A016F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:33 +0000 (UTC)
X-FDA: 85390568466.19.9A2F67C
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf10.hostedemail.com (Postfix) with ESMTP id A177CC000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z4IgsNSn;
	spf=pass (imf10.hostedemail.com: domain of 30qzoagYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=30qzoagYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7x6yP+yOfvdzdlAu2HNp3jLSAowdMqE0gkj3ywLMGc=;
	b=4GZUeX4+nwmEOw4TdWOBJ6Iief5+i9vK/ChMyYCAlLr8Z4Ou8XXRGr15bL7y1wz1J8/H7X
	5G6htTMK2NxGAMyJoyHtCQpP8+4GMHQpVSlYK5tI7Y3w/hULLgPXcsf6Vr+chOjnZsJwEd
	+qi1IQ0X2ru2f5T9DUM3DyF/TH050aQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z4IgsNSn;
	spf=pass (imf10.hostedemail.com: domain of 30qzoagYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=30qzoagYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633491;
	b=5Od6TQpNBdsr9/rfbJZct3rqbj9Oz/+odXCTI3iFsovc6NmX+IIAfOyiJuA098n0Q/DjB3
	7qtRkYVOH8RC72I7NJGO7Sj5ZKl6D7mZ8bT8U/JBc+lLAYlNnYKvz1DYdnKA+Kz5B+bHZB
	DZr9aXlrYozMyxHLRsATzlTOjEfatso=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cdaf2a74482so1688234a12.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633490; x=1794238290; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Q7x6yP+yOfvdzdlAu2HNp3jLSAowdMqE0gkj3ywLMGc=;
        b=Z4IgsNSnkItQc8jzeCFnu1YeA0j0AujskdoCzLLUkI7oBTn1JRyJliBVCjwUL6mp5Y
         fF6LjUSrD6jXb60otKKx0+lq5mh/4KKm5/wEIZ/99ngItnhNHxwo/d2SbjnyW8di4U1f
         NmbeUMw5Ll/w3uv3zUWhpa5H1FZAbMeqqAPc+A7Dw0EFcvMCbr71FhXTwPHY1FoNcnqR
         LO14ubsiWBRzN2M6LJ3p1lyxJP6esf59lLXgJCwpLVXYzPA7zQL2YFMVJIHmMKwciNUG
         4jKumZ+1U42hXV/Bjj0kpIDua4tcecPbn0iM+9d3UT7ufhrzWV07nN9V/dumarP9egno
         Jpxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633490; x=1794238290;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q7x6yP+yOfvdzdlAu2HNp3jLSAowdMqE0gkj3ywLMGc=;
        b=hEjazzNfpK46nT19oEoqycsok+YXMZswChsBBEESReA4jUFaq8ZkBPQAANwcALf/n0
         CIq8LakCzsG2aYHNImkgU7YkIvYINFr9KRYMqrUYXpkqoz21WGRY5JPro7piHo4erH8g
         k0gqvcVg94aHvDJ/GeOEkuuNKjbLPOhfXD7j6Rwqs1Euve1BdIlwlztuBL5jDcj8QQYP
         s0Lz0dhtLSf99desqHHJrwPekSb4Q/N7fJ4ze8q7ZDSCBXtBgKLK5VSBfneeRTfKy7VI
         N9Dw4XK8B3IwJahPPkQFZ6pgbnTdinJscZinEEPfGHkFvTN9etwrUMncq/j8kLfFS18R
         YdtQ==
X-Forwarded-Encrypted: i=1; AKwUvBx7RIj0gnjWqI7CVLxm+i8s7obVlwL8LpatsnZ7LHLRx20a0KavUfGWZSJyxKGInn1ygc+NuRto4g==@kvack.org
X-Gm-Message-State: APuU4Z+89kgN4VTFk5mAp315EkVTt01vAMh//d5qS5zGrOk8O53whlZH
	1uO3XRL57NHoGF/eR1fMydvbehyTiNnDHUnyAc2HZQ8LZf5naXJBwRK6w8LakKSTYtTeh2KSv2d
	WrQeQOA==
X-Received: from pjbgo15.prod.google.com ([2002:a17:90b:3cf:b0:3b0:7a3d:ca4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33ce:b0:3ac:ffb8:1809
 with SMTP id 98e67ed59e1d1-3ae897e230bmr7958871a91.39.1793633490047; Mon, 02
 Nov 2026 07:31:30 -0800 (PST)
Date: Mon, 2 Nov 2026 07:31:29 -0800
In-Reply-To: <20261030133939.630e29af@p-imbrenda>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261029143336.390231-3-clopez@suse.de> <20261029175203.5bdd51d7@p-imbrenda>
 <df9dc526-4275-4784-8a0c-2e4fa8e96402@suse.de> <20261030133939.630e29af@p-imbrenda>
Message-ID: <auis0SaMkRB6odsK@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: don't zap secondary MMU on
 permission upgrade
From: Sean Christopherson <seanjc@google.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: "Carlos =?utf-8?B?TMOzcGV6?=" <clopez@suse.de>, kvm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A177CC000B
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: heyej6k1zd7uwc3zguc6wx8pffxugcqh
X-HE-Tag: 1793633491-823952
X-HE-Meta: U2FsdGVkX1+pUOmqFaAyDdG+wFsbjyTFdKZlZgWbfdw03SwS3WMK5n+4srL+ZijiIhFBOB+4kJpbTm09lt2rYNVcLWx8GpzKI87yeBORG3R0P772drd1lKjjOd4CenjiWVDJqRj1KAgJfDMS9bdlMcaVl0URMP8cG13Ds0OawI5CKqveTaSflKxgjrkiPZ8tdvL2TSlZnJvQTVimD9BSuwuXepefDtM/qmwJ9TXsdSNoW8tT4LP09hSBchkjYPqsqySkEDp7CdW/7CI9iZom/8XdWdEU93PM8Zvk/EG0SfCfHRTqGmPHlf6xONgLhB1vBq4cZAN9nd/RKu9G3m0YDMCJW9emaeJAb4+hLfxjxv8lLeGdaIWsBWoD6vSRz66Px82y9BwrEq+hetyQTDJNTnUoUrzhtjXjsOIUeMn6xRgvrurUyommlk4Al6xnput5XuKzYU2yJK7gUlYWKGOckPO1DqPXG6rOZ2C3BTBUs8wIKth9/5V/xuX16DQdUaXxwqMHZ4U9MCTGq0ust4EWWx1bpm5+y8wl64GHGgbTkguD9/tdRcilwdxCNehPffL4XnBh3W5UXMY+MzDon+LLbZzNKzPCIVpELxesyC8ZxfLFFn9mrpG0rv98uBxINeMhkwsWjkP+EQ4pwB8nwF6nRYVc4UmLL7vkgo2ihYPoJh602XL1hp9Mn7D5KHcLuhAf9oV8byo3tgjjuy6Wsh2/pnjlv0b7ioJ/IynuG1kf6JYdIhtYDwrJyvYEmZRMYCsNdmUQpeFWxKJG8ucQP3nLXjuNRHCqsErNpnRKB8oeCkoLqGHeKGTDnkYVX52TxAeYL4YNq7gyLcFvYtvDqEsbs7xOQoF93en8yPsgF3oMmuPGPBTbjc6n0Gd8yCkjVWv8uoHUkhtxAe4LMq0oSn9VXXbquID0bw1cecLe6Ix6F3YRqdl+EvY/PmTqkkTMf3we8ZBToHgovY9T9gvXbmb
 F72ic+VR
 bLxD8dFYgxPxiGU+Icln/ijWnlnHv5sfJXgsrb7TqDIxllPKWPZbbb0uQgN47kyQ2eIfUPyNJTBqplWX+K9kpWYKQ3nmeC7/8Ys521OT3B3i7DNsBFJ8YFGPJCbJ+pCJAICx6QlwiLrzYFEE+xm/y2oxgynD9nJNJ7UkLZMEApo8uCXlWY7yTFOtGTkNi4HTOVy3ny5Bq8X6UMSSmZAbslFB9rNLw1BNDUPsWbRVscVIkS6fbx3oRqmslnwumxzlTgGkAfxrb+DPJwVmau0YZU7QykbLb4Yp6gZqRZrSvC7nckdH/PRSrDfN0exsR1BQmuPKCb3ky+oLjIXH+BXhHlRmBeb3iryVx8bb5B6Y72MxtTav6qYdIB2sHq5gaXwuwTucOceexW3O7t+DQpxW9Z84oex2tBnVYLq0ZKv3zYYx8mX047lh8ICTwlLnfOCzsbrwS6ERAz98lL15EpJW9y6jEbEumRp/nkFf1QmTpuLu4DUEdIuMOz2+mSteMzGB0jDhTwzjYMl87OIj+5A0Mgf4ytmPtWVMIODM2CmLhwAGnNIXFQL6hJKdzr2oiRyEcO1xxZTuEX8qh5mkE4BLFRsFkTMWwi3P39tgiR/soj3TPnObAAgwzrOAbDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026, Claudio Imbrenda wrote:
> On Fri, 30 Oct 2026 12:11:07 +0100
> Carlos L=C3=B3pez <clopez@suse.de> wrote:
>=20
> [...]
>=20
> > > regarding this series:
> > >=20
> > > on x86 you don't care what the new permissions are, because you're
> > > updating when re-faulting (if I understood correctly). =20
> >=20
> > Correct.
> >=20
> > > for s390 it might be beneficial to know what the new permissions are;
> > > of course we could look up the vma and find out, but since you are
> > > already checking the permissions, maybe you can find a way to also
> > > convey the new permission bits?
> > >=20
> > > that would make our life on s390 easier :) =20
> >=20
> > Right, getting the new bits from vma->flags should be trivially done
> > from the MMU_NOTIFY_PROTECTION_VMA callsites. There'd be no users in
> > this series though.  The rest of architectures still need the notifier =
to
> > tell them if the change is an upgrade, since they don't have an easy wa=
y
> > to grab the old RWX bits. Passing the old RWX bits from the MMU notifie=
r
> > does not seem trivial to me either.

But why is core MM even doing mmu_notifier_invalidate_range_{start,end}() i=
n the
first place?  I.e. why add MMU_NOTIFIER_RANGE_PERM_UPGRADE?  Just skip the
"invalidation".

