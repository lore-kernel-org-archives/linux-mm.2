Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59CA6CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 11:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335BF8E0002; Sun, 31 Aug 2025 07:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D838E0001; Sun, 31 Aug 2025 07:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223248E0002; Sun, 31 Aug 2025 07:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 105668E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 07:48:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55C661DDF8E
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 11:48:07 +0000 (UTC)
X-FDA: 83836879014.17.FCF4C7B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 979D71C0003
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 11:48:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jqSQTbD4;
	spf=pass (imf18.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756640885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vSoKCF0SZqjJfRcA1SFPyaO+CBXZboXgWGfawPD3X2k=;
	b=xnCr6MU5xTKEoRA7JlROA3KAv4zbn/AMltVD6Oxs5BRaSCiPEsShuRjcd2BWCB1Hs/b10z
	FmE1H9KCWjOA9l42Y9vTBCqBe2JniuOD0e1uoaoKGiaBkRYzQnV4PWej8VigMI2iaVO/rN
	ukkvRhtsmocD4TFKeObZuKo1GMiz5Zs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jqSQTbD4;
	spf=pass (imf18.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756640885; a=rsa-sha256;
	cv=none;
	b=UYYDEkEf1Vjmy6co/KRBuRkMPlvv/Z3tvlWpxmaTV5Cz7S2TFuvY+L+jNdspP/nM9JbJfh
	lepqNWfHjHL3qSoouAXf//NADdy+Pfa6F3hKv7qMoZacBfPmSC5C2ZzBC7BLMi4BPRp45V
	O90JXg4gCp7uz9Ih3VV9c4Xvig+2tsk=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-248cd112855so7369935ad.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 04:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756640884; x=1757245684; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vSoKCF0SZqjJfRcA1SFPyaO+CBXZboXgWGfawPD3X2k=;
        b=jqSQTbD4EMxJ/Syfbeee/axRYTJNMBo+eDNVp9JXSSDlTFQXxJjf4YT0nhh2kJgvuA
         yamuxFq5LQrxqgE389LxLgaagUO3jV/Lv41w7CNvOPCYWxSm2rDUw/07uxALJz98dVIl
         2YQjL0F6lg+/Hntkj6xjsqObICIZkxR6NfYvQs3gFfaUsRgmqClIe+cUiNVEVN66xXqN
         cbg82s0l70X8eSUivnCyy4AjcQyMn06MiDlCXlcYvSvOmA1KCtCpqzihO+9/EuAPYKEj
         RoIhmhsqFvHTUV5WFvNWIKwa10bjZvP1xKDlKblbTESkT22wyH63XeWHVMqrAmdATxrF
         Z5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756640884; x=1757245684;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vSoKCF0SZqjJfRcA1SFPyaO+CBXZboXgWGfawPD3X2k=;
        b=Nh4/5g5KEIWwvy8qyMZoEcoqfbsZROS/itZa/3iaxBqLb3GA5Ow+EzoiQ3ex/atzXP
         kacVoUILeeW3ieKpNPGr+6PqMpKGmNZB0m1O9lYVRgkWjhfQ3wKk7uMsnrFuKpAfQtln
         0qXYz7GY6fYcCe0559iOPzJ+EQxVCBcQvvhdnBfQjl4MbuP4id+DCWvS3csvHxk8JgEb
         yeKdSKo+xvfuysXW9u7P6Y3Rnr/b4n9J6P/qefoa/wli9N9C4KA4A8xJlLZ+W4N3e2qT
         O058gxbSHgOqsnqsofKV16hsM5y2IWakxPNAgnE52wqrqO4hbWZ9OF1MGoDFhKaZKR+s
         Nbbw==
X-Gm-Message-State: AOJu0YwfbLiCyRE9dMYdZKJOLqpxITEQtfhPZckDuGdhbp3sbah6Zngj
	AJi5QISl/wJO6ZSmtV3Zsa/px/cv+wZa0m5yXwlQDOVYHS+ZFaKRHSAz
X-Gm-Gg: ASbGncvZskvind1W+EbBOcMFREsTYSWycm23Zdjt9825osfMdovBg+X8Cc8psDBzN0b
	Rxm8d3QdQ6MY2oFwqpfOPuneNI1gFwdh7Xa/lVYVfrkDw4qEFH2qs+LaeG2gU4hktIsl93AyQaT
	4zVl3nEoq911K74osfX3V7rzSL8VfQYmvhMOZ2hnbskmah9z+lb91YO1IHt3VusL2iJhsglVlLh
	wLQeMUpddPPffzEulNm0gFCLtREFrnMghM5Ws+brPPZ9kA98aG3Jd4sFlHMJgCWJw6n8cTQYHGL
	1Zpv4HIwK0LGHrn+JVhsTyN6kBAWR1XXP2kKoA8O6SUCiOIrkNDHYU0AceMJ285iVpykw3y2PtP
	ntPpJspwgXQQabU9ilbxn
X-Google-Smtp-Source: AGHT+IH62/20/Entu4gjWsxdTIxzmN4nnDjHbbkoLQtOwmMjD1ns2mqqyO4tNds0HUeN+Mr8+6v0FQ==
X-Received: by 2002:a05:6a00:1889:b0:755:2c5d:482c with SMTP id d2e1a72fcca58-7723284e978mr4418411b3a.4.1756640884190;
        Sun, 31 Aug 2025 04:48:04 -0700 (PDT)
Received: from hobbes ([2600:70ff:f833:0:8e07:c9e8:902c:6ffa])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a2d7c42sm7636432b3a.39.2025.08.31.04.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 04:48:02 -0700 (PDT)
Date: Sun, 31 Aug 2025 01:47:48 -1000
From: Joey Pabalinas <joeypabalinas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Joey Pabalinas <joeypabalinas@gmail.com>
Subject: [PATCH] mm/memfd: remove redundant casts
Message-ID: <efbbe6093b64a5b19f974871d5262d6e75dff2c0.1756639225.git.joeypabalinas@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="a4oqctm6juezf3de"
Content-Disposition: inline
X-Stat-Signature: paj4bmsbjuse8iu5hth5tjmmth93fxq1
X-Rspam-User: 
X-Rspamd-Queue-Id: 979D71C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756640885-560686
X-HE-Meta: U2FsdGVkX1+eerQ54jaaFcYvIiC/mbTc7BlY9Ubo25mW5STyaTr1hc6Drp8/ChAIT0wbbBLYw7exxsREdiZI5qM7UqIcAD3g8gNC4xQHj+iDkh9DYfxgz7OP95g8GuLsimLuif+uIrqhzZWMbNAnpwvuQHJItu5i02Og0VRI5L/CvEC6FB3JgUYl5npOOLEoBPcome8jZHXhLEdjCIs/SfD3AiD5gWkG4FbhEKvOIDFCDWWLMVbS6qFwNCljxqRVMYaITnwIyyfRPxCmx75QvG96HZmfdDEPTj9egSA1ily1Wffrvckku4yK8JEC7tTpaOn/CIb7LDyK7Gd2hxQTkat29g7YLXcei82zUYgi2tyDKpxU0giHW1GqjsnWlLW4ZtzL4kApdnLVUc9dNF4qU2NLk0lOFw5Ae+9g4sOSKHSeOXfwFazfxCZ6EboWUn6nSI4CZh82Lc7L2A37SXro0cR+kNIoc+JHqlm8gThip5MU9w9kE9aDdfLkUTJk/Xgg3+VJBVNZEWFndMgbVIG2miag7USWUajcvZwB85u3IdKRTCFfz7HNmB/OB88qPiH2mIhbx+0VV2dXx8RPCozoUHdCdr6mJAJVFjpkTQdsy9m1cx1GZPUCNww+bR6gf5l4Y6af8sYvfEL88JT/5CfHUaB2pdBe7ri8zUuRKaTEJsyUquUgOHcrgLscQHZ31MRMyj8YlJo4QfBAqqNmY4iD2VmCicU2osI6bVmOSazTLs8axaxWJey3SDVI6B/aR/UiyEWscSiCgxsFvlaXXGdtXyxcCGyt5R5SpSHjUIBek2bvd6cSVrfWW7QV2YwNVaars/tkgDVVDqzzq0DMZanpOV2Ly6BsTDafBs2WxLrgod2RLhB8onKegTxXSuA7er+hZy1TK+iqln97zfwjofZ5PBAtVmT4zkSVJ6FlFmlKfgw67AgshRCz1gaQlcfA+ncKTEI6j3AtVZEAWVtKu4s
 2y84Q1ut
 5CSYrNnbfoL1iGXAPMbULLOv5Z6oWkw6D2kT4TsUJl5x6BUf0sxFpog6DPXdZ5yfRYM5QoBLYzBTIe6jeeMVBPX0UaxWxRkfQn5VGGUVFSfi9Y4D9P59P6bre2Xf+coAAjeeCSudxDSpjYvvMgzeOVzxAW9uoMz24EYwwka2BDJU0gdndw4OwpGYElUUzS4xd/TIGphOnLewISzr2HfTKS1TXIW8QGBc2w8sL5xr0jbxbxS5KlhrH8t2PjhRlU7zvGURNG1NiX6qNioVsrZvLEOdWzBKaqLBEmi82bp+qQ27QPF8WS3ilt51bNiqTZ23j4U0/0vZOGuapOw0d6asfkSscCa9cTsPI1eIPJF5sznQAh7Vn41Nsqk+GOy8ILyA6ne9e92+Tg5dN/OdXVlXzooe9fD5jjP1FSnP6Qakr+v2zFb861QNBMEhrv6DUnBXxq0E57UfPbgjdbJOzcXSD1QJBclR1Na7kwQSR27T110OWJCPNm4eoxYlsl03JMCXrR1wv9A+e0n2DFXDP5gS+Nj0U96KU5FVFMZxVo8tJPax+hOKHNu9ViMQPyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--a4oqctm6juezf3de
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: [PATCH] mm/memfd: remove redundant casts
MIME-Version: 1.0

MFD_ALL_FLAGS is already an unsigned int. Remove redundant casts to
unsigned int.

Signed-off-by: Joey Pabalinas <joeypabalinas@gmail.com>
---
 mm/memfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index bbe679895ef6a191ba..1d109c1acf211b3c3c 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -383,15 +383,15 @@ int memfd_check_seals_mmap(struct file *file, vm_flag=
s_t *vm_flags_ptr)
 static int sanitize_flags(unsigned int *flags_ptr)
 {
 	unsigned int flags =3D *flags_ptr;
=20
 	if (!(flags & MFD_HUGETLB)) {
-		if (flags & ~(unsigned int)MFD_ALL_FLAGS)
+		if (flags & ~MFD_ALL_FLAGS)
 			return -EINVAL;
 	} else {
 		/* Allow huge page size encoding in flags. */
-		if (flags & ~(unsigned int)(MFD_ALL_FLAGS |
+		if (flags & ~(MFD_ALL_FLAGS |
 				(MFD_HUGE_MASK << MFD_HUGE_SHIFT)))
 			return -EINVAL;
 	}
=20
 	/* Invalid if both EXEC and NOEXEC_SEAL are set.*/
--=20
Cheers,
Joey Pabalinas


--a4oqctm6juezf3de
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEx6b1SGGPTKxTmPDYqoHu9CTxowIFAmi0NmQACgkQqoHu9CTx
owInvBAAqC1a16w2WsJa7SqEebfyH0+msptOthtlyU2r57KCN4hj8vZiM0nB+3Qg
fQTCPrKqPXXs+0MMghYutj5+KPOfyAQHoXs92ECgSIh5norP6KdeyLpbpzjH+wGq
+ltBFbY/kL7SbEV28DqD6MGEAGHmy38Z1P09leLtzG5i8vcRQyq0zZXvqaf7lxAu
c+l8u1whxEqlYAh7r2WumkG1MiFidgg5kotLhGgGz4Se4wIISg+Jx0F2qrZIAjD4
KvJz5xmJXRoTyRRdOBxD50UuoCfZORFD3Veh74qwbYukd5RzTl0XeWhAgRPZxtFa
0vlz21zJIO+Uhu259sBP9XGmNFnsjavj6/vCgB+1Nl7BjXe0LyW6XbA6jBxa15dO
VhvH3CcQ1JnZE+4e9wMzesizhvhifFBYHdsILnNboXnTGvwwNWh2bt3SGfzureJk
hGc8ViTbIsSn/F3yM5yPKDAmoD0yj4z+IU92BOMaQAWBYDLXx7HMXxbS03S+gtt7
XBjkgFdL3EOmFc5CMD8lmWJN/RTn6zUvnpC2aF2Jis3N8nsZVyEbTPjAQyj2rpVF
QCAcOwHJ8mrsBzQpc70M9VwebZ9p4xs2Dl+5SLaHV3AXqGRKamXC8+yG2+gHKaai
OVZBPW7mW2LZ9TGvoRL++zBZZGNQ9WdAPHfmZs5U6M5RTtYyTnI=
=EyiD
-----END PGP SIGNATURE-----

--a4oqctm6juezf3de--

