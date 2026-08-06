Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E704C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209B16B00A9; Thu,  6 Aug 2026 04:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2096B00AB; Thu,  6 Aug 2026 04:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F78C6B00AC; Thu,  6 Aug 2026 04:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD6DD6B00A9
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:33:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 629391A06AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:33:17 +0000 (UTC)
X-FDA: 85070180034.17.53A619B
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 993BA1C0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:33:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=X2cL1jgV;
	spf=pass (imf21.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005195;
	b=pDCfdwxKSovdL65s+4XGpbDTuZj/08ENY6RyQr3XSBtH7ZycofXfZdgqf1ZHeTf0XN+eCP
	LInpwS7EiB8qp9/+97Kg2ArXADlXk1vfX7RKywFI09Ln75nberSo7sg2r6WSBD0fPLuk8U
	cDpYj2kks8WImssrkyO1rdyLK2B70/Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=X2cL1jgV;
	spf=pass (imf21.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kbwwwq24L3XnIIcYVbUsKDAVnxBveSW3by8s7kuBsxU=;
	b=MHigyXuZtuTfYs8sFKEhrx19JEv5lT2bgnhWhAs2WAREZKHQ75G0fwICGimZPu74FY3YkB
	6RlvNrFntoPvhDZOSsXKoWgCMwhmCMITpfI5Yg8xTEkLLB26oJL0WlVfTTPHg7G8IRfmmN
	gy+CBQxP2GvEs6dm8IK/BSQhVSKrGAc=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954aff6088so19087735e9.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 01:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786005194; x=1786609994; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kbwwwq24L3XnIIcYVbUsKDAVnxBveSW3by8s7kuBsxU=;
        b=X2cL1jgVneHXOKvZps7IzLPs34+RFu0SMtZo28+G241+oPj2QmvoXikLIrCvMaYJM5
         1hYZyDcu22D8KNP9LP6VVOeRjzbIG2Tf5hf/BoZer5Ixtl1Jj5mB7sEDobsAC/53wBmI
         ckm9V92dXygsISoAEJV4TXH9t1+Eus9omCU6Dv6unRTUgdtKjGeBSRrEbjOB2vKsgZXk
         +Ox4DSaoqYtPicZ5k8H33zlXsc2byXPl5C82crXPB1Oi7lzBBeZqkYw1zQ1zHW+6HmS9
         TtNNqauKuFIcmqaA6GFlQii/v2jkTUsSWUZJgWCT+VgX/EvRmdsCRrz1SUq6IxgCF4ez
         lkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786005194; x=1786609994;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kbwwwq24L3XnIIcYVbUsKDAVnxBveSW3by8s7kuBsxU=;
        b=lABJ1XOTn4FSHZsX4kdDx3+xEkyYCniOjNx4p5aqqyVeLQnhOtskPNDe4gHfjBaAPo
         UDQi1cMeU01vWBvwny1ESHcMxsuruRTS8cQvMzHX4M9BcM5tmfzkpmFeZRcwDbNq25ws
         eHRBIKooq+0yO6KGLKHmqFtaSqTrgVdTvB1Q2zUz7sOuXHwjarwlJuED5bcbjDFIt4Nq
         WzCgQu5rvIw1FKnOKcv/50NTlpgdfcadE7GH/S+BB99gT6eCJAfYUlAAbERO98kkQCHh
         7vK2VNNKo+I/QCepuF8gNal9Cam/6A0XKYCa7tq2gC3FuTZYuldNEvowEtKPZE9C9VGW
         w3sg==
X-Forwarded-Encrypted: i=1; AHgh+RpYkJ6vMcjrEoIthMNAl95yZbmCqhQ+jO6vATNYabuYjrej0E5+4te2jZClJ5LzpzO2B8dxkUEzQg==@kvack.org
X-Gm-Message-State: AOJu0YzU60UilZcoioU8rZv8v1lhSpD0IlXXy61N1GOsGYLaBHn7puSy
	5rwG3N+x4tGaLT/gp/WwHRECryvkRPFLUD0qn0EucljC1niyH5VN4nzDa5MUMT7OtgeJO+0WcdL
	NLzwastx9lQ==
X-Gm-Gg: AR+sD11vzhPWwqNnS9kijFHfyj/8tD1U4jteyrUPBupocoIYVjfZoHmQ668OAPAemFG
	2ELTpPKFRAYvR+YV6qj0uKDnbqWDF51+PcSKI9wSMlH8tFN33SfxyCfYMEW4H6h1urpTdHDnhFL
	03X+yKgpoARYe5EMG0WxqDST4TWptJ9QscQgVhalvgpHoZsIvLOLdbQIGOEWc4/3wW9HpJ9RERq
	uMe/9KrqK3Fp7zvihntkvHeTq2GfF6oSwrL6plH6Ktgy6ArglwyWUJYlh2M031HUqg+ZBjHRgdX
	go6SGD5tmMYFD5I2shyxeMtFUwyvGmgbvmby5Mk1zKQoG1M8O/g8uiznsahN/lY+nbmEV1L0e7s
	QPGBZH+ukJd7Sias62jrSfqy6F/1C1ctYoem7ZGSsWVxEE1zrW5Dgw684Z044CexKrRv86MhxFk
	9FfBSyjrYslJs5vun5qO9vSDybudzlBuigsuu5IeYoYiG17P0S52SM5CVXZsdhsgBOWF+dz+5Dj
	0w=
X-Received: by 2002:a05:600c:4688:b0:495:6bc9:62b0 with SMTP id 5b1f17b1804b1-4994e7d1487mr163017845e9.17.1786005194371;
        Thu, 06 Aug 2026 01:33:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542858b2sm48595955e9.14.2026.08.06.01.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 01:33:13 -0700 (PDT)
Date: Thu, 6 Aug 2026 10:33:12 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Wilson Felipe Pereira <wfelipe@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/2] selftests/cgroup: test_zswap: retry subtree_control
 write on EBUSY in test_zswap_writeback
Message-ID: <anRBETN6znndbjyr@localhost.localdomain>
References: <20260804042053.56940-1-wfelipe@google.com>
 <20260804042053.56940-2-wfelipe@google.com>
 <CAO9r8zM9H8iMOE2FE-H47CMUAExf3VcCf04anT=_Ja=m=sbr4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nas2iww3rivojx2z"
Content-Disposition: inline
In-Reply-To: <CAO9r8zM9H8iMOE2FE-H47CMUAExf3VcCf04anT=_Ja=m=sbr4g@mail.gmail.com>
X-Rspamd-Queue-Id: 993BA1C0002
X-Stat-Signature: t3nurntwdr4zao4pq3b9a5wn9cey3iss
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786005195-488070
X-HE-Meta: U2FsdGVkX1+optSnZS/63K1T3/kAzZBuYpLahXLGk21vRJIUa7zIYxoKDQ06tNrOjCmHM5bGIWRMk3GewZW5NkyxBKsqdzYLOoiLwTYx/ap9qs6dte7mKfQ3BGJqfEcLJNLq3esG2xteXky4eQnwa7uJt5W51q/0en4rwZMNYUYyJniIiVMPRMfP11e3ThZC4sVbXkQfSHUwb1z8++TtujRvxR48dwQqxYo1eV68lDuxmswMIcdDUVzRlENV/cHSXAjVmgGRWjMQhOrTeHxrt9++oaaom62hSfAn/+UvUrpfzebDnK4bZc//VqF9V+0th+M0O+Qe9gNNAtynmm6Z5bUtDOSH3oY4IUAdKmc0pLCpTfEA9ilOHgNdl4qMke6bvkGvm7ru2ClMKZMXQkKcdA0SfRxh53VuknDJwxNR6m9YosltE8fl/c1iDisd7JJp7kAHrGk1bSgD4s/l33Y6iEbewxcGOngGUaQN/ONTPMxzF29hN6xGlAv5buCk/0YOgoeE0rT+OuInjUIyejLX3LJCyRtk36V8RpGZmNSV2Q7mx//f/w491DaJWwtoAJol3aYXNiL1btFnbdo7dtfBZoaDuwltsAYxr/nGycOI08VOL9hf3EOKNmxjr7jme0+eljFdYR8CPQvV9gIM4r5PY2O3mXsRfM/5vsVP9v4eRdpgHCOmJ7/UtGhcnm8c5Z/1BzBiQ7deHAJ68VFRAiwFX5OZ60IAKelGQUIfU8C8GrzzTT9FQhhtK8OllpuXOBE/pp4xQAyBv6ATkFlR30RZFg3lpBSEDL7kWl/ECxtwB8+mZ8K9owuY20yOIjl6tU9a4ojspoHUFeqaZztK5eQB9MW187UBsiXx5UtWPj2F9AC5Mx8E/55NlVrAVqe3t0oKkhfN291EVfTyyPBcunQzcqz/Yv+xHmVX/NFEL0ZPUoENmUTghXLXiX7q4NmQ/hzHQneJE5w4Tcyhvhb7mUX
 J5T8vzJJ
 H+6epXkQQJxxe7F1LUOw0oiwxH/G/BA3dM/N893EKU/G3aExzMs6ebE6u7fvoAuEAAxP0X/1PM9AXeEVOVUbJgJU+g0kHOKmrniaci596y/xDD+gVMmLXLwwVeHDihoJRgXy6iGnKIxMDCah719nPBs7DrEb20ry6oEc8O8QdQdjcT2DmAxFpquDboKFRSK39DMwQKotrv8eEnwpHIrfIkK2UEkQ4Xr1Y2fDzeLzUZO0VjHLXJ3+8wfTJek6UFIBUreBmu8eEb43knJfuC8xbNiH0yv1hSHZTFR0H8x0Z7DsPQrTS6ZD/eSjb5YKapDxNfgQlXMYUXg2IKmzcaQgWdWZwiIoKbaQ20FV2u6LiGjIBbMvVnq4I6syDw9WUwdh+XH9EzCnmh2kv/rMwIZv1Tdmoyi7SHHHi4TQfG4DmGlOpK7PV094vhcsdwWMMvRQlRK0251HY0n30XLrlT8NTKhmjHCA2hXIPAM7TjpABxXggwCgdp5/tdXbwNykQIiXu8Q8X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nas2iww3rivojx2z
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] selftests/cgroup: test_zswap: retry subtree_control
 write on EBUSY in test_zswap_writeback
MIME-Version: 1.0

On Mon, Aug 03, 2026 at 11:39:14PM -0700, Yosry Ahmed <yosry@kernel.org> wr=
ote:
> > diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testin=
g/selftests/cgroup/test_zswap.c
> > index 49b36ee791606..312d51887a1d8 100644
> > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > @@ -407,8 +407,11 @@ static int test_zswap_writeback(const char *root, =
bool wb)
> >          * Thus, the parent's setting shall be what's in effect. */
> >         if (cg_write(test_group, "memory.zswap.max", "max"))
> >                 goto out;
> > -       if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
> > -               goto out;
> > +       while (cg_write(test_group, "cgroup.subtree_control", "+memory"=
)) {
> > +               if (errno !=3D EBUSY)
> > +                       goto out;
> > +               usleep(1000);
> > +       }
>=20
> I would honestly rather create a new cgroup here instead of reusing
> the leaf cgroup as a parent, to avoid any subtleties like this in the
> future, or even split test_zswap_writeback() into two test cases. I
> don't feel strongly though if others think the simple wait here is
> enough.

I somewhat agree, I'm not sure whether the recycling brings any signal
to the test.

In the case, the recycling and (re-)enablement is needed, I'd suggest an
explicit check for emptiness, the best of utils arsenal seems:
	cg_read_strcmp_wait(test_cgroup, "cgroup.events", "populated 0\n")

Thanks,
Michal

--nas2iww3rivojx2z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCanRGxBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgPAAEAnkONm5a6/QU81n89rmaO
gX8APeieENGJZExlGWvR9vIBAIX33lBPb1rWjVE6b1pdC7aLDpHTt2AoQfLJFbmA
yzkN
=sJQx
-----END PGP SIGNATURE-----

--nas2iww3rivojx2z--

