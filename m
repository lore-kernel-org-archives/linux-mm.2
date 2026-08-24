Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C77C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1466B008C; Mon, 24 Aug 2026 03:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782716B0092; Mon, 24 Aug 2026 03:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649116B0095; Mon, 24 Aug 2026 03:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23B936B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:02:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C858A369F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:02:41 +0000 (UTC)
X-FDA: 85135270122.30.B7AC7E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1719E40009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:02:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YZI6lOHM;
	dkim=pass header.d=redhat.com header.s=google header.b=HSNtzeus;
	spf=pass (imf04.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787554959;
	b=yA4qoYzaXdhr1nCSKauVfVAOoUUE4FSkZmeVIKz0W1cfV/VcGf65v/NE88D3XfHTS9k6MF
	vDkStbzDVNgNZgOS9PUPObdhD4HocADdG+L3RmRh8B7eTIItJlOYWpS+FCmVHQRleS8ah4
	AVOVxa05siK06akuiaGB4CEh+WEMC1w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YZI6lOHM;
	dkim=pass header.d=redhat.com header.s=google header.b=HSNtzeus;
	spf=pass (imf04.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787554959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7d7HgiMHwmpzIOyoUl4AR6/ya+8tZe+ferjW/FC15c=;
	b=y7jBVhyt5+Vbimz0bNtHGJBbIyyP0WWqfmUShqdjhx46L7k1jvvK3s8bgsK+mX3JaYjvAc
	qyNp1M0Jbq5bEsBHzAdl9Fheg0L4VkyVkr8RBXlKXiyuoZigk2HgPJUT6R69SJbW/S82vz
	cDU6YMB0zb+kzXXa/ROzK+Gm9cIJwiA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787554958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G7d7HgiMHwmpzIOyoUl4AR6/ya+8tZe+ferjW/FC15c=;
	b=YZI6lOHMxobrn8Khnj1cJd0OyZXjI97Awl/KRm+AcEaktQcYm8ftUwh8VNMQTiYEzeSqcY
	9oO+UKTixN3Vhwxe+GYUtBZkp8Xr93s7p7p7aMv9oxw8ZS3sUmRH8x9Vk1vmlSYccg7njA
	GtWWHfEM/uRzTCcRRv1+HLA3MC47DNg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-6CqNv0J1NLOhwnkyRp0PbQ-1; Mon, 24 Aug 2026 03:02:36 -0400
X-MC-Unique: 6CqNv0J1NLOhwnkyRp0PbQ-1
X-Mimecast-MFC-AGG-ID: 6CqNv0J1NLOhwnkyRp0PbQ_1787554955
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-499b99a8a10so17689145e9.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 00:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787554955; x=1788159755; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G7d7HgiMHwmpzIOyoUl4AR6/ya+8tZe+ferjW/FC15c=;
        b=HSNtzeusc8DeExlzPueFcMFfqzzPJ3lECuiUotgKsCkhYPjrO/CXkwyio9VJwGxzop
         wgYZd3UAMGbB3A7PwkK4d6YOirLrHdhzdpOJSDMYvPT7Wf4wgYQX3no3bHV4B5h+iZyo
         8FVtiA9dYqA93+dcBCEdpWvnFst2kILMbK9HkGE4GMu4O/MhgaQsCnRBVMzYBIDs7fMr
         vZH/OmKwiyw9QT/iJqBSm3iZkRHvyktiVIjnmoXhNVjxDP5z92NgU7+lW8eHJU6iplO/
         d0IdAqnFrnlSJ2lk/ffQDQtbjr6EOtTcxINdB7UFselNX9WrGA8TUAdf6sXy12QXceGR
         +IWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787554955; x=1788159755;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G7d7HgiMHwmpzIOyoUl4AR6/ya+8tZe+ferjW/FC15c=;
        b=FqhmDSPy2eP/bPlP2EbwGhSRXzdsF/RAyJTWm1kATXmK92NOS3dQWg5Yl9u6midF0W
         HFxTqQvnuKTLNugg35LsiOVoTSsFiJVX/zTsnGOouWp6uSi6WMfZpCggzp1CPO62wBOf
         Wu3mnuH1yT7wYb/4Puz8+VPO6tYfdHFqfz8VhH0gEcXRfehCVsaL6uujWyB1fTDJXWZi
         D4oYNKtyxglhTAI1x2xENJv4mRAELrLt4iX9IHgfpXAzwX4JgLbah7amGbWFZipuy5cU
         tawXgkvPX9/p0LTnVf1OHx1TG7tdmDkYPUlRAiG9b9cYiGqh5nCGRupMCt9j+GioO+jY
         gVXg==
X-Forwarded-Encrypted: i=1; AHgh+Rp6ikvGQ/+hjhHwbkGS0H2SF9rdUUblM7YAcuO9hCBZ+B4XUJBuiSelhzRcevw4cTfun3ivxnGLjA==@kvack.org
X-Gm-Message-State: AFuF++lhU8eHQbfyTmMjpGKbg8K23tQHVYqEwz3DUVFXPvnKav42KTFr
	FEb3lZlXL7nMG2CKUJFeBuosjJxuZjhrvNMTl8AtILSEH2/KTyo0FJ+Jd9inZpVItlXWX4cxETe
	04COoFAEi+Bq3Pr5obAOU0/YF9h1C3konXnhsZW/9H2mlxGgSqnPg
X-Gm-Gg: AR+sD12qoS+GYj9iS55p77wk96TOMSlZnehYbs4LL3Wn/WDrhALqz2nnt//gNL4bEbU
	Cjm7KAlEorK1L/my8hZVOzaiRB5a0W5GxV4bKw3qF2TWywTNqX8fERPKemXSp9oMRhaf0NJQArN
	Or5M/27YJvBl9MMRJ5SQhHbC5Je5pOwQe7UySgy2TC5Ki4Ux0M0vytUH0EVmlWRExRE+giYFxNp
	vkUIlfQuKjb0BjMw/k/BwG/WbcQ+xS2vo4lulwcmkO71hYRPhLSBxDrqz2rl9Gqfl/8vNoVC2ZJ
	WgZndbXE7y6ksF5AZBCQDINnzDBDtB6SQvr/SBGyjAWDszWtQlgnzAk8fBy3/ySyfUPEs+JDMg=
	=
X-Received: by 2002:a05:600c:4688:b0:499:5f80:83ac with SMTP id 5b1f17b1804b1-499b91ad940mr188040475e9.7.1787554954760;
        Mon, 24 Aug 2026 00:02:34 -0700 (PDT)
X-Received: by 2002:a05:600c:4688:b0:499:5f80:83ac with SMTP id 5b1f17b1804b1-499b91ad940mr188039125e9.7.1787554954215;
        Mon, 24 Aug 2026 00:02:34 -0700 (PDT)
Received: from localhost ([2a01:e0a:a99:9822:ca7f:54ff:fe01:374c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499bae8bb6fsm103521345e9.0.2026.08.24.00.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:02:32 -0700 (PDT)
Date: Mon, 24 Aug 2026 09:02:30 +0200
From: Maxime Ripard <mripard@redhat.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 03/11] cgroup: add memory_cma_accounting mount option
Message-ID: <20260824-poised-meaty-shellfish-9a09d2@houat>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <20260821-cma-memcg-regions-v1-3-d21b165b8440@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="l2avhy4pfliwz3eh"
Content-Disposition: inline
In-Reply-To: <20260821-cma-memcg-regions-v1-3-d21b165b8440@redhat.com>
X-Rspamd-Queue-Id: 1719E40009
X-Rspam-User: 
X-Stat-Signature: drghf5dkcnfniq98ycxokgbpez9qnhix
X-Rspamd-Server: rspam06
X-HE-Tag: 1787554958-401727
X-HE-Meta: U2FsdGVkX19cLaNa2Gx/kGDjmonsgflolBy6pwYTPCWmsz216Q9LJq74xsKqOdNiFRrePTzGQc7mBSZddmpJvMdQtx0DONo4VUhqljkiC1ryXbAYOEsvHXEHxBGITKOfAcblDuShwupI2B1NQyYUZbVZ1ybiSnqa9386yQswrDvDydJjRyhaX2tLy8mo2y5WA6DtFSY8caUinYJUto5tWPDpo9pHvyQTG8ybMdqWpko7NPnMgazC8zRmqzEg2jBA3ihazzXgBtUhoa5ni7SycTGuWSJibhnBjak9Lj/Nl1g2nY/ByFlo2YI+yPmB/SDQoVYsZd+pQ45acQcBK/iOpuvBLRgrwdqJweIW/Q/6u1sS2q5K6P5sERby1zqvmzzxvkuYiR2BZy8oTjJr7dkVGnY7+/AkbXXOLFRDPBfmMHRFCRiCqV6+N81noms4LAKKV3N1J2IQEizjgAQAGovE5W0GXjIAVzZS4nNfKYKruTH1jnnaWc5kSy22TE6ItcRefq/Eop/EBrKFW3b4N765JTBc47CuPAJmlpCXvOyQTafMQ1g8zh3GhiL69QXQ6rr2scEqHLTTnFLpBC3ryKmW9EdswlTI3LDHIEsOWh2i3MM6dCRlemZR/jBWafptpsctVSFpsGcmNYVXctKdpEHW/QuyUD3B4JpkKK96zstnYiHCcSrmugPcK8i7NgBe5Xy1wcdrcscDKGf4kyMJZ7V5P3iajT3VcIOxf7wNqg7YZGq4jqiou3URVV+XQTEm8W8QQOhFL63MNq0eP2TEvMajL5VWpmfF7lvfj2UvKM9iDVLpgobC8Y7lsj9JPt5WSvHFFpSqaRGlCzGMD5oeV585OseZfmuVzExzsVlJKNiU6M2ibW9KNgKNXowMbT3iLJ4k7GnCEenG+8RZ+xq4H1x1YOsrFEDZWOSbbfxFzUp5BV8IteQr56giunT4VEpucZema87quC2R3l25clnNqzt
 dUxPqpcm
 WlDOp35XDt2jiGnEmtBiKvmlatKuPyNosvPao4KeYt2LxCZR3IYenq1+wj94I3KXuzUWM685HqedyOy7/SrL1mIlPf2kqnj7s0scx2oC778I+hztGj8pRPqBRosJ924Y6A53jDESa9FSDQ4FJNLZIzY+IazdpTZLJKVpIdrykX6/FUL399RE6FOWl2ZgXKmQlAfp6syEzlXjKB+RPxjgJDKD3A4oQNptGvU8Rij6hMK4yWjljp8ue+yYu5H3SiZmshxS9yw6YxJctgCKhyLE0TvisC8SBi7geQlcvc9fOSOXLvV4thvB29zvsax1lgFX1usiNGDKLr9duhNRpCvrhovGKl48invrdmypg/Rt6mg5P+0ZWJDCbvXa/7MevRZMgbtb7uD3npTYBexfhf/t2MQut3GCWuRgKdtC/jno+uHLJQdkmF1bGHnAWVyOp4V/9FjpQqbowtJDBOHOyfRHrsoUtMG59ciaJv4Hk/Pm1ZLtO7QGAZutr6RBY0V8med2ua7qFp3VUiBEGZKZUnEbRkfMup5wwSb5VEXfFGq5XU3DrxIcXxqIEC81B5M+WAXrLytRk4A3FwFCehjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--l2avhy4pfliwz3eh
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 03/11] cgroup: add memory_cma_accounting mount option
MIME-Version: 1.0

On Fri, Aug 21, 2026 at 02:56:55PM -0400, Eric Chanudet wrote:
> Add a cgroup v2 mount option that will be used later in this series to
> enable CMA memory accounting under memcg.
>=20
> The option is made opt-in as it will charge allocations to the cgroup's
> overall memory usage, which changes existing expectations.
>=20
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 20 ++++++++++++++++++++
>  include/linux/cgroup-defs.h             |  5 +++++
>  kernel/cgroup/cgroup.c                  | 15 ++++++++++++++-
>  3 files changed, 39 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index aed195a71cbf..3dfc13f31a0c 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -246,6 +246,26 @@ cgroup v2 currently supports the following mount opt=
ions.
>            will not be tracked by the memory controller (even if cgroup
>            v2 is remounted later on).
> =20
> +  memory_cma_accounting
> +        Count CMA memory usage towards the cgroup's overall memory usage=
 for
> +        the memory controller, and expose per-CMA-area usage counters. T=
his
> +        behavior is opt-in, so as to not cause regression on existing se=
tups.
> +
> +        A few caveats to keep in mind:
> +
> +        * CMA areas are reserved at boot time, memory is only charged to=
 a
> +          cgroup when a CMA allocation is performed on its behalf.
> +        * CMA pages allocated while this option is not enabled will not =
be
> +          tracked by the memory controller, even if cgroup v2 is remount=
ed
> +          later on with this option. Charges happen at allocation.

And what would happen if it's the other way around, ie mounted with this
option enabled, then remounted with the option disabled?

Maxime

--l2avhy4pfliwz3eh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaovshgAKCRAnX84Zoj2+
dmgFAYD2QpXyIkC2UzudfuMMWSQyhPMvADvZ8Rf/HrEEqUh/MjtRgmrUG5NqgkMI
UAktDh4BgIRrcGChUBI+vsNkyPAnIa8ElouZIe+7PjdeK6u1QPgT/QlxiYNC2N8b
AaFU79ONPw==
=PSxk
-----END PGP SIGNATURE-----

--l2avhy4pfliwz3eh--


