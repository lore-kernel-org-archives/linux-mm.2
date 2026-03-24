Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3357F532C1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233186B00B0; Mon, 23 Mar 2026 20:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AC36B00B3; Mon, 23 Mar 2026 20:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1483D6B00B4; Mon, 23 Mar 2026 20:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0430B6B00B0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:13:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BD2413C28F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:13:30 +0000 (UTC)
X-FDA: 84579032580.17.B3A89A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 968574001A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:13:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5WeZhN8;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774311208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7KBpqQKpwlfK7ajHOR7kNEPFkjtTfwbJMrpNV1Vm5M=;
	b=4j+q2KF8Y8MZaXud2eeYiVnQgW3gzDpo2ysoW1IcLf/uKldRKTkcMYtnSUJor9J7M9Nicb
	HXm+37CSI0H2GfdXnjyrcAnTZ/H7PzT3ZW+iYnPfhs1tghyZTG4GTAWU9b1g+31YOg61CX
	YYf+kRXhnw3OdMWwlrQ1ejTUYU9x+B0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774311208; a=rsa-sha256;
	cv=none;
	b=V1S4TvK8CwzrwRuNNXdNkGvj++131gdY3seuSarIjAIYB8b0NyjgPr8y8JN8z1lyG0ZeZC
	Nuiq5d7xAcnTsc3IpgRwGHPBZEaeeTA61NVfwnIPTwxA3oeB1BMJgEJUDSUBm+RlUIJkqL
	REiQq6kVmPvbAKrhzW99SP0DwEwJ048=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5WeZhN8;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E92660120
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BF3C2BCB5
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774311207;
	bh=K6vWPNhQfmc7Mv4vXHrObzmoR4P9iWMg9c5bCa4Hpis=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=U5WeZhN82O5IaGPhmvAaAKFOIrPgm7g4HTEZI6df+K8344IaSD8bBDh3XC9wgcoBW
	 JxgMtKB2WKJ6xujQXooqOGl7xHtVPbeKP9QjdDUSFj051Gr5OqxA99O9H3lI2tXUWp
	 QM5sF0ZNhAYq4R/dM1B8h2Ub9ixreDMVvNWD/7lf/Wuak12czwEP4+z1yXAw7J7GrA
	 v3UZT0SzmCrxTtYbG3roTyPMqW+XT+GJgth7DrjXWrzPUkljhE6FOFbGzcpp73a81q
	 VvH7oERXT+ZoVGA9JGyqdsyeUHpd8EhRC4mcXZ4TDF6k2chDr0sNGImbKfk5H80VZA
	 6ZDukShfneRcQ==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b97e6e48b24so149725566b.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:13:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV3W048Zy9prZrEGnl9wqFqsdxDCIe9R2GmvLer1GuqbwSOo0df4OHSwF4b7KHbqDut4lV5fy73jA==@kvack.org
X-Gm-Message-State: AOJu0Yx4J2OdEqPVUn9O9oAKtsuapJ5+RoQs/igeas2Ph8TWSLNkecH2
	dVCd6ILqKocfIYSfps9K2UaoHDMVoU1VZQp1KF38AJZ8kaEpxBRhHTapmGxClNkjhFZWJHUMA7b
	s8G00tBGByDD5lNXa5Te2jywMJHqZpjk=
X-Received: by 2002:a17:906:6a25:b0:b98:528b:8461 with SMTP id
 a640c23a62f3a-b98528b96f9mr684031466b.52.1774311206601; Mon, 23 Mar 2026
 17:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260322061038.156146-1-liwang@redhat.com> <20260322061038.156146-2-liwang@redhat.com>
In-Reply-To: <20260322061038.156146-2-liwang@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Mar 2026 17:13:14 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOwPnP9_AMX7Z_w4jLMYP=Ujs3BxNLWVXHOEAKVGFGfmQ@mail.gmail.com>
X-Gm-Features: AaiRm51sDTJLIXwe6wg38ozJyHVTmTYj7Kk418jSg7POV9iqwyQKa2-Q0lx47O8
Message-ID: <CAO9r8zOwPnP9_AMX7Z_w4jLMYP=Ujs3BxNLWVXHOEAKVGFGfmQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, yosryahmed@google.com, nphamcs@gmail.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com, 
	muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, longman@redhat.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: azc3p9qx8nhxcyxt74ckee37q5rjmd78
X-Rspamd-Queue-Id: 968574001A
X-Rspam-User: 
X-HE-Tag: 1774311208-63377
X-HE-Meta: U2FsdGVkX18LbzwBeovjxupLbWUV4SdE6Lg4u5hjAeQG47SGN8Ct9j6Fy1uuVkHVoMNGcScgnTN3eGvgXKGqnRDu2/30P/rcebED2VVBQh6h4WMGqe+zLN2qj8D1xc0cvFvxWzX0R/MZbMKl0IZbqliuivhfZP1ha2zurb06FOxe/K4dF1k3Xhun4JLO4TU/SisHDto6X3ryYLTk1dSx9A57fwhhxdfL5nvabRDy9wEHSAW2OLstcEoNs3wtfqI4jNhI/NQ8XH6ikeoMz0gcHKQ25AamEan2sk1h2meTTO369aK+ZuZrWi5IeAJnvDIHWJOpEVR3btQDjRSkMPWCweDK6uvGAKhgMQObT+7e7WvRvh9J0mffyBSvpFUmGzldTXo7CabVTfuDTi3fWEuL96oLW7/C2LGFx7KyJmMEk8a/01ZTNAt4phz1dCfYyf8XSMKVajGaDrZv7I+PbvqoEChSHvewLKuHmW6JM8GBsQ3zPbDURs0vkrgm9RvbFz6ZOpBypzcowZ9QWO2L7ZIHXdwHmEiLrfXJQ65tUeK1gByYEb5GKeLn1RZ35p9GTjJuOV0GZ3DQmxAhKJitYRhqubrJQOMU8PSd2g+RlKbLhT9tyyliM2yaxaEgnVXHloIPq2umDHtWG5ExIpX7bo+i72j/Xyz3kcWPB5js2yaBeAfkyIwJYYGuu5LiAyf3+y9Ax91Qy+E1ZZvQD/H9JWBQkKoKiotmJ9zruVh/8npTqaqWMmLtVBwzcHr3cQrepWl0Jk+LP7/wAvFhIOrJyUkCZLpl4dP18Ps56DXzdGnMDisJq9ti8f0w+ng9IjpAG88mlVuOEpadyvra0gbWu6Dt7w1mFhLI6Own25ngRAj8t0kGWjS5vQtKQVFCHLGSVGHxULe8mgGHuvm4XywlxfAm+MEuugOvUsVBR1gDbodkZ9R+0pFm3Lr4cWYzOR6NU9X/ItDLV9A/uB0YardNHOc
 FymettXk
 kUYb6GAyztrS/Ow4sRYEK/o3E6ocncRK7eBeAxTZAtBMX/f4tjj38XQ8Xp1ppK4sA6cL9cvo/xDtFvg2SVWcBxaE/Lsfzx/dl2srGI4OnPv19SjehXP2fSP5L053mu2JpnnAzHrzAXzrWGS7a7Fsy4m7L/VSnE0XxJcOa9dfx/Sdljs4MsANBWOyUuBysZ38fVyrM0HZY/4t/6AQ9rf95eV6AnonIikCPVg2cCGsT5YxBEmgxOuUaTiaC1JY2WqVS2OgGnjuLEF7TEQg2YdgIBamvX3KZljZWdkh5LysIrlxCE7CFmfR7Dk71JUUxHik08yfzaucJkDelQN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> index 64ebc3f3f203..e69d845d3592 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -589,9 +589,21 @@ struct zswap_test {
>  };
>  #undef T
>
> -static bool zswap_configured(void)
> +static void check_zswap_enabled(void)
>  {
> -       return access("/sys/module/zswap", F_OK) == 0;
> +       char value[2];
> +
> +       if (access("/sys/module/zswap", F_OK))
> +               ksft_exit_skip("zswap isn't configured\n");
> +
> +       if (read_text("/sys/module/zswap/parameters/enabled", value,
> +                                               sizeof(value)) <= 0)
> +               ksft_exit_fail_msg("Failed to read "
> +                               "/sys/module/zswap/parameters/enabled\n");
> +
> +       if (value[0] == 'N')
> +               ksft_exit_skip("zswap is disabled (hint: echo 1 > "
> +                               "/sys/module/zswap/parameters/enabled)\n");
>  }

In the next version please put "/sys/module/zswap" and
"/sys/module/zswap/parameters/enabled" in macros to avoid all the line
breaks here.

