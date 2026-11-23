Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9DD606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDlnfJv+
Received: by kanga.kvack.org (Postfix)
	id 14C3C6B00EF; Sun, 22 Nov 2026 20:36:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD056B05B0; Sun, 22 Nov 2026 20:36:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012376B05B1; Sun, 22 Nov 2026 20:36:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D97486B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:36:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5ED22A078F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:36:04 +0000 (UTC)
X-FDA: 85464667848.07.ED0F8F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 86F43C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:36:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDlnfJv+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795397762;
	b=LGL2/tDF8MiZAt/GDp8x9cZhfhYNmjfx0A6wsH5vQa8dOIghQ7wMqyxpFkPJetQh7NYtFA
	JLZm7U3XthhoOc6Occ4wZWFG3SacfHa57QcVXsKyhCol0vl4Jp4gn26/iAhK543PuY/DL0
	2SJqojkRUegr6oySrY1/1R20jOsJ/tA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795397762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtCu/Lv31KKfbMFIllslMcSrDnoqZxMzFxkbUKmBWlg=;
	b=0GOI/k+NKHVYzjdh7BkBDVb2h1QoxpAOZbySYElO4mPd7VwQVaJCH4q+Hvf7+tZRJpLZdP
	kTHDSrMoXEocKBj+6fQ2LjZUcYacmRIIH0PBert+oToB/vpY6v/XI/N24NtsizG4KhBmSM
	0y9FzDITkimIS71I5dlu8w5y5DIBQdA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDlnfJv+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBBC361AE1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541BF1F000F0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795397760;
	bh=LtCu/Lv31KKfbMFIllslMcSrDnoqZxMzFxkbUKmBWlg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iDlnfJv+Z9rSHd8GLoqfvgkwVTlx53iufTvvD1pHLs2ng42geuqVkxpT5Kp/tTTyW
	 RjkgvdXFDsSSJmhS2ex1j6QN7ONvTnCDL89BErBSWbjAQC9rv8K8NrJSVsPzJjlXUa
	 RjvNPgluwksPzX6TdJn4l0n8C9SiGmDURxp70FErfFfuemISKxPM44v1qiCw7FjTV8
	 LlHrqbsHm9giby2oFgQWfzrvSNwHapobAr/VMZCjswN/qW1SgGWJ0lL940f1NjeLUG
	 QqGMoA6q2RTOimIGb9AczqNtGeY26CzsI5mAw0i+vrZ3RoZeICd8bSIt/GA1Y8XVqa
	 4EHLsvPoaZltQ==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-94962d80d34so172749085a.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:36:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFCcG3nY27Bjs4IWeGR2E7yEKiyKSelQkTRTzMUniHVLanmYaOzbJ0i1n+dsM3dCEI5sWnrmGx+CQ==@kvack.org
X-Gm-Message-State: APuU4Z+jNarG+mRoQ10nvrU8GJXLj8PRlZcx8XHxVJi2d2zLjk3v2DZ8
	gNNpB3pFgegKCqDk6+uksi47v3r5BlCw7UDO+L97m0Wid7KbX+jwjLtny71TDyVtpsrTlI40qHE
	alQR/LJP8P5VsbPEb5AbX1Itpa4zDGaQ=
X-Received: by 2002:a05:620a:838a:b0:949:3521:b627 with SMTP id
 af79cd13be357-949ba9ff2b7mr1644030785a.38.1795397759398; Sun, 22 Nov 2026
 17:35:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116081403.216452-1-max.kellermann@ionos.com> <20261116081403.216452-3-max.kellermann@ionos.com>
In-Reply-To: <20261116081403.216452-3-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 23 Nov 2026 09:35:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wit5jKGn4L-NDTqzxDRNS8s8-FV3g0m5e6BOcG2Gx2Eg@mail.gmail.com>
X-Gm-Features: Aa3M54oWK8aP7uwb_r3XD3rWcrMQ-9dwA-s2hQH_XdkfS1nJ0lq-9viUM0tfLcs
Message-ID: <CAGsJ_4wit5jKGn4L-NDTqzxDRNS8s8-FV3g0m5e6BOcG2Gx2Eg@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n4pbhkm9hwgbwwcmht3zy6zamsh3msuc
X-Rspam-User:
X-Rspamd-Queue-Id: 86F43C0005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795397762-378367
X-HE-Meta: U2FsdGVkX19PK+nlLMSxWTR+NUQvOYDZIrv+hY6Mq2+k++4Q2+Nr0aLZP2vYoZlq1ah4lvoaggEoBKpa7sssGch5fHgPwDzenWbj53fg0E310A3OnIefHs0BBLQsb1DiCUpSjeqGi2g3iNKqN27WBwpxLDCA2f+ZgcX7+ETXlPLN9oZ01DN2UIYsMsCwsa/r3mtzApfaI0tqbpZw5YoWy/fJQ7NlDH2MHV7pkibtVL4IzmFH7qQN4d2OV3gamSUANqiWFsGM4JM1c2pxGm+knfWlcu2m+ZyWE/VqFjbOjvWSeSu6jXb7Ww9Vz+WduuHRrFZvdiCUbQkSePg+TdX5diGyqnIgRvKMQJZKbA5MFSwUQjb8AILRtVw2jM272tFGLjSB1xYYhzsXcRC8E3G8izqXDjkMG8fVeDLrFyfGMGHymlGHIHlZQwyjrzLdjKux3sRynxLtx5xXAKR+f7mH0KL/tBH4p5ukUDejR2AO+nmH3v70gZzIMer4IxHl9VF4MWrFNExAoycr81IgcitTYOg6/96+cVN2VHPjqCqgy2xQeQjz2vY1Wiypam1Y9w8+gtTe1PbFDbyDjAl1GzAOQTMpmTGAzoIcx7EOB8u82wR4nlwld2S1dnQJcRVuo6YUI+aMJLa4VOC7q5msm4vjrLXWbJk62JOMA8qzJobyM+UYR2W6F0oI6TTo475MF8iM/t9+7tktewNSIEc8wLo8Tr5rrHJ+PUonFS14otUJuHCwgIZ8O4fKseRpo5nAVltnK7s6qhKM04pnGfWDgQ3dZ/z5cwnyG46xuWl8jh0QJS2oJw+lUoV5lpEht3TaekRouZwjLT7LfgIFWCyvRdQs429NoeHcazh1o3cJLRVWf8Ifhb4poEV5aHfdWG/2N/YJcQkL/y89y2m5Gl6FMpUVKEqC7Yw/CkoNjicBZR0wAp6F3ZnbeZM9T5LTat3M/EkXF/i61f0rVDoiouxizyh
 HIwK3PQX
 8OAd4tYE/3eZ31qgdDC4M0RNpbfkgABMTBV5tQmu8aYSY9gEzsklUmwlOwAUMTSUV73bQyeXo1fVFMyU4iCgrI6VVj2Tc0QoAzlTXz0Dr4pT7yyo+KaLYt/D+Woa8N/5NVPDkbCJO+MtpfrmxTzfkfbwAiAyMkf/VRiTYxgUT41h2O7zeYCLgiEbUCCtMc/H5uixqJkrrPFDnwr/ByZwOvEfynuJalvwNcYaGnYx4sImbI/hyxoBccA/if4OFgT3dzV8bp5PBnPxAgk1U1jM43ikQOykOlZgsIk4FZ8Cb5VSZUrAjq3AkIJlI0MTuSpl8JHp/+IxmzrgrYQ4gnlrCPPDdMGK6GYM37YJdRPDVD+LgBgkx6CvM2Uruedda/Zb0XvWd3kYxFbnGfphE/uMzNIgzLg/eqOMiivC0u0At7omp6t5rxCQAhrcpMICqpQUZcU0SGt//JcQgKYG8f54ywBtTLpvElHGU2Hl7fUsWKje3DWMfA3RZ4771FN0XYFvhCuFzt2M2+yGmsTGpCYrkK7nWXx18EpXXUcxyyACUITp+8w+h/N975msxM/gMVuApBq7swU7VEW+Khp+fSYu2mU44bTjm1KtsuTUMbJ0LE++cpjvg80fG4ZUJLPtSIUUEh5RXOENmhtMwRoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 4:14=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> Preparation for the following patch that adds tail caching.
>
> For simplicity, hlist_nulls_del_init_rcu() is now always used, which
> is also valid during rotation, because the entry is immediately
> reinserted under `memcg_lru.lock`.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Reviewed-by: Barry Song <baohua@kernel.org>

