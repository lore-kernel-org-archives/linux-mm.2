Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AF7606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LCWG1ZbL
Received: by kanga.kvack.org (Postfix)
	id B3ED76B05B0; Mon, 23 Nov 2026 13:16:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9266B05B3; Mon, 23 Nov 2026 13:16:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98EBD6B05B4; Mon, 23 Nov 2026 13:16:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0A96B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:16:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5429FA4540
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:16:03 +0000 (UTC)
X-FDA: 85467187806.26.F189D94
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5734418000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:16:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LCWG1ZbL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795457761;
	b=PZaq+upML7xR2weIAkKhvDPybytnXvaQoEIimsk4A55jvixKvduy5E6HIWeEy7Ao9BAyXO
	z+vimTD6RIcsMUV1dqS5HuKNzGQJYnLy64GlXp4r7T4E9Bu6a9LBEAW7UaWr+w3ZMkm8Es
	uiRLqyDbWlVvjVcpdXVDmTrGdlqgAh4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795457761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFQZ5Vfgmmi8vCbKTEjvDQ3KYqVEpaJ0qjUpV/3d3M4=;
	b=K4OyOgY2DcTTNxG5QC61U9nCF+dJQ7PJliZUxJMDv9iot1aUzMsZ3ZdjpT/9L+lhzgX5Em
	7gwOLvR1S9zgzw+PEmaU0PL8tWdCwbL9T25quSW33sYVGCPIOD9ho2tLcmh/hFUoxGz7q7
	YNhk0sc4I8yQoDtVGiyhEAU8tTDHJX4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LCWG1ZbL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2f05b465cd1so16040185ad.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795457760; x=1796062560; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TFQZ5Vfgmmi8vCbKTEjvDQ3KYqVEpaJ0qjUpV/3d3M4=;
        b=LCWG1ZbLX93WLGT2CXJcFX9U6ADhVWfrpsoUwLgk8NWjE2YuDZtwbIrEVLzhHFoxJ5
         ACoYI5LF2YcwOnie1k6D/hn9n4q/4QkqYdTLv96I503kckjfLYQ+b7/2+LKUCgH+AA/Z
         yiTPx7teVq2V++s+AQZEi4fn2ceSchTMcCfmODEpRxrqMagCUDGaUe2eQgNd/0r2Kb5P
         7NtGspuAWwkWbND7ygV14oe+h9o3gSljU51OYpW5eHjuqOmcSKTw2KG9MBloPZmGRNkg
         P0xC8MriMkqDLucY3nepdYGvu/vVp8zQNS5tw+qS0+NMiyC7Ue9hSsfooBWIUYZ59jfh
         p0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795457760; x=1796062560;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFQZ5Vfgmmi8vCbKTEjvDQ3KYqVEpaJ0qjUpV/3d3M4=;
        b=Gnm5OyKJyxoaRqnF2/skKXuT6dbxw+i6Zf4fu8E7408iOgGz/VpiKmqdT+uZGAQ6hf
         S75MqgxGQaEwAAkFuvbr/iH0xwjwakrsFGt6nmSWXjiOqu7mFvMnN4OpHm40x7qwaHEr
         dQTKPx1RtAYD7eYEb/ePd0/wQnEQDELE9PWPmTJY1zIT8zK+OC1uxE6QvsdH8///H4JZ
         GLuTtEupcYUwC5oFSBMZZTBW8VDeMMsqA5XkjV00RQEIIMRwzK7Hfx1Akg9OR+O/VU0D
         zsoS9ciX3/D9yozoFxOF1qgnQCD20kRWGO4iX46HC6yRZEVkHOqL/0yHjTcJBT5AMkAk
         H3PA==
X-Forwarded-Encrypted: i=1; AL+hErGAJNXJmFB7s23saagH3bG+REd9xlzft7HKw4KpvUupVhcY9Up2UI4Z6sByWbXjpgAXC36KZtdBxQ==@kvack.org
X-Gm-Message-State: APuU4Z/dUuj5lYEcT2dXTRDkpunPyqlsQtWDhzecRNhXL07pDgdtXXid
	6vpd0WNFHZTA12bimLGzvclg19uIOa5CnwdLJ+TKdx+3TxyirT708CUI3tXnw81VqA==
X-Gm-Gg: AZFdTZddyIBW1iQKvWcUJagabaPpbiDN7sGi87xalL/ciDwkBIq3mnMHlZzYXyLq/vy
	F9BDG+5c47XepwgMd9s/2U+nOnmNsOhstYebDF1cN3dYnt0hzElb1THIVM+U0Gxwi013WL+EK8D
	K/zlPXHLCXhMO0KQHmEqtkq5X4udYW3kY9BYsPumEvcHDXyujtvOhnEpaMVUCB8LLp70enGOTP7
	1zAiKOnAAKiwdHUqm63oPj52xNGHY7FZqNjSR5uir9qhIcgUpzqZy5yC1W7ZPNv9/AqJyBV1zrP
	YaWtDjyry+Ce53nQ2zrL5uXvcsveaBi75jdIenJAai01rdDoWlQYFsXH3HvTBRq+GL2lAX9DOxJ
	qaQ6RsW2zvNoQk1aMccyk611nh4tjfi6Tao9s+3Ft6gCg8usWEA5pd7Rk1CPQK86vP/K1hihkly
	m2Y8d9fYZ5lYYRx2qtFjLJAF/pL8J3xyQIyhcRfPDjBnDULLxMwcfF0LueLQMWcPTDU2mwj8Z5N
	Hqm5GMCarIeiD5ehyGl5tKXb0iBscpuxpKh5NL8o4lsAF2aEQDmzeBhDdJrBCUG8XYnlLcHF989
	JUqIlV+Pi4C00afZaG9ILxb8ApQLHGVZXI+IO6wPeCxHLkz1wVosn7WBwsVbI9cN
X-Received: by 2002:a17:903:94b:b0:2f0:3618:f170 with SMTP id d9443c01a7336-2f03f1acb10mr114729435ad.66.1795457759518;
        Mon, 23 Nov 2026 10:15:59 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f120016sm57723715ad.58.2026.11.23.10.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 10:15:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 10:15:58 -0800
Message-Id: <DN2SNNBMY48X.2HS6KSB38QPK3@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-mm@kvack.org>, "Alexander Graf" <graf@amazon.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Christian Brauner" <brauner@kernel.org>, "David Hildenbrand"
 <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport"
 <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>,
 "Shuah Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
Subject: Re: [PATCH v4 09/19] mm/shmem_luo: Leave freeing the preserved
 state to finish()
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-10-dmatlack@google.com>
 <2vxz33sv3ef3.fsf@kernel.org>
In-Reply-To: <2vxz33sv3ef3.fsf@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 5734418000F
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 1jbnucsy344dq8tajwmqg8aex4zze8qs
X-HE-Tag: 1795457761-807371
X-HE-Meta: U2FsdGVkX1/LTQohw/RDmpbLgoydPZ6yVjTr7CpReRGYK8ASH/CVJ8SsJ7AhpJj1wjIXT9mQKmnf6nxzH3gZ1FpCthnhN3YwXAC95Pgn0qVmQBo7GwvwpJGatCzOUm0CnNpFkB10OAyxxQ8iwTkjT5/sGfSSZtUFWSOcgrVMIrwti5nCX1HifzrZsk4CZ9BFdt/Id4tiwlShgImAGtekQRRsSSrQthXmtiS43sfIxQlsiXAVsYGNYZZLbadMq2QbC9SjymySMNLG4/l+NXt1o3iN9Xz74FI9UHwNkbvfTGuH1ydwd33U37j+YwQstWQ7YtIEMfWvm38c8j5m/ju68NHTfFXtMDeup1mFhUU7ZNS3ZDWkHuzBwrEy7qUGSMbpczDhh/O9BOKGHOZ7Ha4xO1Ii4mdWoKzzboXVITJ+OmEt9VOnjEoEv2dmOEw9Uxjo0Id9U8VrJ3yIoR4SMSx//ukNZt97d3sTFPWbTbmPisxH8aP8APuTC+uwZcsTiCRj5H/kcCF07qVQlte1C6dzhjJHhfVmW0tcUBfyePm+RKJ1gW5/KZPLjQtnDw/u8zFwfprWFRI7COeqfw/MFs2afRYBIeDCOEp1Y3Ur6QtW9l2ax0QXg0hwLzC1HaUN6lC5JL8VAC9Wxm9hfbkJzx6IITocIsiO225gWCMACNq9vLvFb4+GmVMoHy5G3uZHX6xRCUm/GuU17kG5k1nN1iH/4Tz4UBKJPNQFoafJEl3ikrW71J63bppB+RjF8ZB/7sn0TDzK9EHe5g+wi8fDlR1DcMSlYTHO9CqSzh7rdpI0n45vCGU1Y2qo1exuq5QF8I/ewjKaHQJF11SIzQmu65focnisXdmvkSduILofz24eeY3urF+3oeaxjKUm7abhBxYrm8BFwuUPlVvvFWRg0EmVMvVh2ov+QbYn9nCOtvxSdif357/YPfle6Ztekhj45KXta46U8qqMUxGuz81s9lQ
 NIv45Yo3
 VPX/G02KKIHvVj8AIV7r9wqsEXF5mOfb6hP38cnDeMY73Y8fGlTQEzOzlMKE2F74uldU82KqHvjatQt9OEPYf7p1rjCR/xM2vhwCsqNuALUvwTa7K/Nod4PeaBm9Z5jnACwHjS9IYfhnXsHcb9YzcjvDbr3ouwcn2n31epom7rNRfrJjAIRMRV6lJBGodAUVPashRtSYfu2g7NvcV+T/L1MClCpAzixYW+W+15zIbC2p1zuzo0y2gKcdfCgzpX5xVZrSjY1hkiev7c/2EQZIZ5cZNzuLBNx34oUX7Uz/mBHDfOm5AcXKuNfrYPr8q1NvQ/tFGQqPT4qt/G3jR9eVPPqW4IEdS8cB0j1lZg8cLNNrPHG3hBX3zWgfK6/mBnMkhJYAQlZg3hRRdlc3emYUWYWWc7Fhzb/MdfT6Z6rBaooJZX1Jtu38t9TE7VPsKkZULcQK1RlPMJZ5nCYCh/fBHVxkgC32HxxKOzDcgUgVlO71Z3+00zIazKUlVYsa5RML6T7a094QwOHhrkXWZAUxbnkWN8W5hbDq61HVTPM6stbsImk9Uz6L47Sy375S+mp32sjGU5KStiXx+Tk2Z5gzgQl8xMndaTK5rg5xmp+Tg7zM3DmxXdbcbetiXHCdKTmQrFkoLjxF37UdwXr+Hj+Of5OibTwEcIBvkKqNoFgE1ZjDWaGfqkaf+ajzKaiKKlXm1wlRK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 20, 2026 at 3:55 AM PST, Pratyush Yadav wrote:
> On Wed, Nov 11 2026, David Matlack wrote:
[...]
> I think some of this is already fixed by [0]. It holds the folios until
> finish, but only in the success case. On failure to parse seals for
> example, it leaks them. Except, as Sashiko also points out, in
> memfd_luo_retrieve_folios() the folios are freed.
>
> I don't think this is strictly related to your series so can you please
> send something on top of [0] to fix these bugs, and perhaps drop this
> patch?
>
> [0] https://lore.kernel.org/kexec/20261110175855.2437084-3-pratyush@kerne=
l.org/

Sure, I'll drop this patch from v5 and send the fixes separately on top
of your series.

