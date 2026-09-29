Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC52CA5FAC
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 20:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BAF56B008C; Tue, 29 Sep 2026 16:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86BED6B0092; Tue, 29 Sep 2026 16:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782066B0093; Tue, 29 Sep 2026 16:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 576926B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:36:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7D41140585
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:36:34 +0000 (UTC)
X-FDA: 85267957908.01.8806C40
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0827C140002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:36:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILU79W6u;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790714193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HY+uK+9mHQGUTtMN3D118HnRijdv0U2Tb9WBorVAJXM=;
	b=E+5yTj2+l0pQz74P/sPUqhakY8CdUhLFYWhoCvFvXbpGAC3+XlWJEnytbGv8rTKDY+SE8R
	3rkEY3X6HgVJ5J/BFpuZl9jbIlT1+HXDX+HwiJUMYKJV4LqLze5Psw7gwTmhShvfWP2dxo
	1TP8GYT1g5P7Nf/AkA1hFieHKxibsX4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILU79W6u;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790714193;
	b=PJBBKzIw8ZnCwVzuvnfWNWgOMVlYqklxr75mSRPAphhJxQVl3epdvymZSBMK2zoAePLuxp
	zKxgreZrGXcQq7Uqbq/iO4tC3fKIeSGc9xlXI1OPfu6YGMqrCpHfdWLU4TVygF86aBOmnm
	VzGNJj0IOjt5grI20RC6L11pQPiDqi8=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7d2bb404so5349575e9.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790714191; x=1791318991; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HY+uK+9mHQGUTtMN3D118HnRijdv0U2Tb9WBorVAJXM=;
        b=ILU79W6u2pcNOdo1foaZ/uoh9Je+HtHKXY/upgLnii1EC+cd5/27fmjMdS518EAZj/
         0cALeHw1lBTEs2H8c0zUypIEwyLvh7qRa1rC2sVUGK6Rgl1K3TLhh1gVvyA/XJRO4gKa
         lVFhLzNlWuIHE/H8egGqzLPyBry1yqvOopKbll2HRfjbWVbSHPCWAYsu7eYad0mdcMXH
         YuaqzjUAV0tq5BH8Mvjs8gDtqbjxnXTOpxFAjKH8Qt+Hh9vlout5O8P2Mg88HvVUyqaK
         5v9mnLldq5M/K+9E6mIr5Nvl8sIyOT+XjHvWlI70+n7VfUFagDHYMGV5D+fomf3QpZ0P
         O5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790714191; x=1791318991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HY+uK+9mHQGUTtMN3D118HnRijdv0U2Tb9WBorVAJXM=;
        b=Ps4tin5KPC2kjGU0bjX+MfyKV2e0Yz+qHLzX6JwVZUnzY5eaZayj6nhWvMYa/+rNij
         ThMKzVbhf9ahKC3kfphxwaGrb9KY0cwNmIpFCSgoSREkkJ2ChbUvr2++bZI6HhoWzi8u
         9cYIPa7GiiQBw+2mRbyd3nB9bkMK+lKi17fmnOGYWG5fT/QhSt5mZtFl2U0xB+oPE0M+
         wx52o/PZXRnB+ruDPlTeMf940ZWEpsL74zD8VaCU12lkrdXBZ354JepdEKR2YfQi7Gdc
         kdklyRDQFDvoGsWHUnZsSCC7wOpau++q50Rghkx1RdTwanCTh4p1okccI7zWCjN9J8dj
         9J1g==
X-Forwarded-Encrypted: i=1; AKwUvByxtcigUMk0Eth+w0gsPvkGUsJJnmsvqKW5vGnADFgXTcf9Y/2SCJ8FwSmH8BxKsEz5XxJ6cuwihA==@kvack.org
X-Gm-Message-State: AFuF++kyB0BS2qju7FIf8GZ6JGETH+jLZ9CsamJPdCg0m86EKX2rKW65
	511AaCVPbDYqVC1tLJrdFlbBVuG2ESNRVl2Xh3D8/lcAcrOOEM1gXdQ=
X-Gm-Gg: AYBFou3Gc4HVzExIxXJz7QgrB/uGDlgjBAERFRwSOTt0H5LgrJIJmtrIFmIXaFFQTJw
	e94JxW7+xZjKRelkmTLMIZSoSM0uaHLd/cUyI5jmC9Kjp8n1v5CkAh17RkzYJQjGb0TeowuCJFy
	Me6o4tcsOwjAuyEEKChzIdLyxQA8H+imlOV8DEu8PQNM9vk16ooOwbwakFL/XFEFWfNclnvjOmK
	2QfyU+BkZ4MEULfI3+YapPwWoNriVrugPu1KX95CVQehyq3vWXSDKwGgAWMwF6Lu6ieOPq399g8
	/YaaJqmnL4cQ4gaw56i+foZCA6xZva53zI2epJM60r41ssVKwCltXBS/EnlY+o9QKQxLmbDDHFU
	g13dPEON1YyLN7YdlqXlrusqw52zwR22WXstk+2y+hgRT8jg9N9Gj23iO8dgDQuil1wIceEYJQk
	pVAD4dizGr0VOjphLFfTiH2FWMf1Mwbwmv6UVkpW40eNEciHHhyIqEDuM9ArNv1pRpq9u5scHY0
	cW8nGEhUnLZI1DVOtNx+3MnL3V5SWsKqgMQG12b4gmoIYbIB417QhRcm5UxRovobMGE4XRRWU/e
	Ou6aFSc=
X-Received: by 2002:a05:600c:a08:b0:49f:d69a:1a04 with SMTP id 5b1f17b1804b1-4a015141deemr4262055e9.16.1790714191554;
        Tue, 29 Sep 2026 13:36:31 -0700 (PDT)
Received: from Ubuntu-2604-resolute-amd64-base ([2a01:4f8:13b:86d::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a015019e5asm13682155e9.2.2026.09.29.13.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 13:36:31 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: akpm@linux-foundation.org
Cc: hnkz.64@gmail.com,
	gabriel@krisman.be,
	krisman@suse.de,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] shmem: fix unicode_map leak on remount with casefold=
Date: Tue, 29 Sep 2026 22:35:46 +0200
Message-ID: <20260929203547.229191-1-med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260929132129.f22de2069651aa2eaf56bf7c@linux-foundation.org>
References: <20260929132129.f22de2069651aa2eaf56bf7c@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0827C140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: hn1qtsss83qrdh84znripdrkhqez831t
X-HE-Tag: 1790714192-984715
X-HE-Meta: U2FsdGVkX1/l1tH134XWRD5IQCOybf4RBQgnkugG/HLfMNqIlQ/1NU/r4ZK7Cpc7adRjDjUdPq58KSB8yvaAQuHTp7FBbdOVsB7yrAOYpbNxZ06uNFjfBmZxM+ViOFQfe2Ptk8g9rLKC/hlbByUuOYAo/3L1xwpBVTitOnFc8YkWw/D8o0tHI3LQ7iJMVzIWlQcjiAkxnKSzrJl5dyXYp4qKRSa8Ssts4/K+cQziTWBUI3s5WFHKP49gBwybYtyhSO7l6Pho+c5/u/LzIvMsUM2Q7WDFYccfUssYvGglhV4ha9uUeJQS8T1ZPe1aAzXV0uwGXkGeeWXQu25600thq57lLCWu2R+CaymQP8JG47FYhZcDz1h7hhmd/jHUvmTqOjoH0J1cnaTakLAR/KBddCH3z+Fh0D9N97izC4x8l2UFN/EVPy2LaOOHPMPUd24Sn9FlG2iNAbpax3vvVjGofFIRAUyngAzgCSd3ntzFwK2IROmFoACUIryNlUn5zhWh84NnH9Cswd9k12R2H0gH0oyTK1BfJOnnV/OOvpH9+KspLo7zzcWLsfeR2yb9qBSeB3u8YK1+kc21/+oysHx9FSedJvZPpMrGACuVQrXUG1URRMJR05cKfVZTjQaUtDHZd3G1Kk7RF6OXry4nXF2OOpgrFLdgGNXErU8IGw65wugBDyLsDDD51i3URqebxYh7BYAd/oB+9sjBUk1p6jnc85H+PZDg0KkFlDZNePm0nRqPt34d6J4J+VJIApR4oPc/HQF0F9wO8P41cIJ0rjx6xoEvIc2ecooLn1kNoG9UaVvDOoon0OULKSi9qkyJOMCcaJZkJK4AJSMkM8MwIVXN6vDEdmq6Uj8UV8AoTQrptOQKZLLDU3FiCT1kNznbVGfWzCuCP2W/24patML6+3XarjYZAdlILU0sR+LZxTK3Z6kAABu1LZH7VVJBELHHaZu5PBAXX7l0O1QGwhZGayd
 umk4ue9f
 DCfdG6jZ7V7jZwlivQ+Hg5O7kfA0E0OcCX2Bgyhc4kLziXhI8A3/qkJGQ+y1BBUHRUy/7jSlaX1zPtT1G/BmUPcgIJRzppbaw+FD15AUqQPkhqE31ziCTvwynbboKSyhqWdXcSO7bumSoVeXaUH1pvPcg/z6s/4CsWs8E3mzrmToyXNVxsORusPFv9pzl4j2H7osMjKEfepCgaULAfej/3+nfXC1SjijX4E9bjj1fKaFUMTcRgkxhwiye5B2mhWqyYRY6rX/JE88xehkEMNFt4gDrokvv6zF2+ZP9tFLGYLN604iWp9qXcZhOw5rxZwQTPn/V1oZfprBp9YPMD06IK8RKh5vUdaV1B7XWXIxFaI9OoBonlWtYHKM+uNld0+9QskZ7r+N5lpKFv6xhb1eIj+jvneq2Mv+UWbsjdiPFR9TgtZ+2nkzP8mUCQuOfc1xvDbbhqGhi8x3UKmKSd5y0Jsolb7DQHUylszCEA3PFDhw8rAFetuJo0qky4TvvKbZrgyWcK8mLtdDhpmAcYb9K5+RH9wPW0B0iYZ5SBN3L1wVBTwwZjqrIjjsQSIJfOtydkkoY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 13:21:29 -0700 Andrew Morton wrote:
> I recently merged
> https://lore.kernel.org/20260827152516.805622-1-hnkz.64@gmail.com
>
> Which is preferable?

Kazuki's.  It came first and also covers the repeated casefold= leak
I sent separately today, so please drop both of mine:

https://lore.kernel.org/all/3a57ec70731165b4b1244fa89bba95c82a666df8.1790712330.git.med08elkadiri@gmail.com/

Thanks,
Mohammed

