Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F4BC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 01:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DEB66B0092; Wed, 16 Sep 2026 21:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190216B0093; Wed, 16 Sep 2026 21:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7966B0096; Wed, 16 Sep 2026 21:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E17FE6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:38:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C0A3401DD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:38:46 +0000 (UTC)
X-FDA: 85221545052.20.25FBF8F
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5FA3940006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:38:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VRRRBgjj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789609124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBi200xN/LUb2MXPCKUJDiGUegD8jgMjIoX4dvMv9gg=;
	b=KZESF4OwdW0rZ2qNW6Smqcf4bFyJ95ZsNc5oLnhG60LjpjtBu1NBrNLaK343JhNI4U66fZ
	GZHfeEW/Sud+7nhG+Q1mxsk3DqIO0MzSFwtchldCbrJjZp0BDd/zDaTWicUxY31B5xxfpr
	1XbAR8wYgvZUl9+VIxbbvwB0D4hQLtw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789609124;
	b=UPfZcAlhWFGgaq1Sf+tILxs2sjYc9tfQzfJe9k8Xza3oHyxo+gBxDtZghR1MZ1hzqb52QE
	JYSCFDV709D+XK1/8A2uznboQeYnE66W/9AMA79QJnYiiCCJVTUK5fPxaXBOXfxXb2aOUB
	HBRPr0FLUfUt/zc4f3UR+3mp931Gvkg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VRRRBgjj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2dd77300825so2912425ad.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789609123; x=1790213923; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XBi200xN/LUb2MXPCKUJDiGUegD8jgMjIoX4dvMv9gg=;
        b=VRRRBgjjRLouIL8aVuycROeY0nEQe1z6yaVxIsQavMQIT7QWWw+Sf16wSAD8Vv8sRJ
         3h5AXIFc3kt756JaS48VStoNFjc0SkWFtTtwaIOMNb3i5QMD1bvcnkZDQH1BIk0PnR17
         mtVd53sM5DxiTBKHXwesvSZa1iY4XPEmH5Xrqz8NWRufvsUkKkSokkGjCwkOET2zQ/qM
         zLPFrxTRV7iv/g+NUFSaYsCHwDrOykkmMyKj+5YQjoAIe5YmsAK2ociNGp5RzTFq416K
         9pOGYjE/7rsFu+SubW66gYnaMzHmSv8UFa2/j34VYuM9EZ+yvR/iah0zcuDv+mAoLwMh
         hKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789609123; x=1790213923;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XBi200xN/LUb2MXPCKUJDiGUegD8jgMjIoX4dvMv9gg=;
        b=xl8tuvwJME5e7h0vIn3YTkGdX6myaBHEMvhfw1QxFU9qVkdVgiz6BsX3hpwGlTbomV
         UshpwWCV9gaM78aitaG+oS5W6VcjBLmPX2iGSZ5Up19xYdMYUnTY3iWtix/BKp54CDHu
         p7EAYGjXZMJZBwWvKGs1DtlTL0GA53faC65o34t0IvWhvLVA6qb/XeXHQRLwWHc2ssjj
         LEG/FQYV/xijq4pnv6y6ogbIn9bnIN305boK80kT5ZSDFwnVRbbYkYGxTELHAnRNEMfN
         Xfmi51QqoLaPXJCDayr4kTzx0xXWzrliDLH28WVs5DTX7HZ8VGWCtTl9AMzBgRVgG6X9
         9tfA==
X-Forwarded-Encrypted: i=1; AKwUvBywYW6jKnqhFTr1625phV2hRcQW8Hl7JIAiOA+5kVnTzYpBMVkGBMbte2pSbc3AUye7DSTK+CvTHw==@kvack.org
X-Gm-Message-State: AFuF++lAIx0Z0eNYnY2VGJeY6gccBfDvlX1XU5s1QL/SHAmW2fkaWb+l
	tPUnj+fNesVzTStDZaHjhrE6QmqaZFBq+nbhmy5JfpWRO20kF6zGTgdTySgoVKXzpw==
X-Gm-Gg: AYBFou14nPILaEdnjHXqaKKldi6aUF13YHmDrO+/oXsns151Bh7RbUI75daVf1pxr5f
	1IQwKap093mSfvFc/usn9rIGMcCp0l6eesfDLbnw7X1aDiL0B/APYooL6mFq96lPjzLAtpGmCnb
	6oxCDMig/VS+zGNKPpi8MNwp4gI0PY1nbnzlApI5QojsvvktaSg28UjQNvVpCVb4k6qgXjm9lA0
	5slTRT3vlnouTGXehAw2brT57ziSBYi3AxVs0RMusXFE60B3NWxE9OL1DcsXxjQM4jqVnqUx/3S
	Ym5aJB7WAlvfXR4ZneKtCnNwX9M45FOLmfZZzukBCfOo8V0L+zyGObTjBGXa+Ely6+D7prekJbc
	ye8uANxMWe0Hbc6NKHhow0VLWPX8qiSeQVbHiPoqQYHwo7OFucBUC5fIdwcLl9r6FlZ0U+7GuIu
	J2cEGBmJ++zlSNqbMJhHVPjCcla6e4xU3C35hjgQ+n2jHW0f8uTQOCmzYBCc/Egat0xPrmIrd5K
	lYzNWTuW7dXM0u/jCsSL+wqGmuJNzzGiZq69w==
X-Received: by 2002:a17:902:db0f:b0:2da:dcd8:713d with SMTP id d9443c01a7336-2dd8e635b49mr90622135ad.15.1789609123093;
        Wed, 16 Sep 2026 18:38:43 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:b6f9:c198:e14b:34c1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89d9007csm18335155ad.5.2026.09.16.18.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 18:38:42 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/damon/core: charge only the part of a region the filter left
Date: Thu, 17 Sep 2026 10:38:36 +0900
Message-ID: <20260917013836.100213-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917012420.101087-1-sj@kernel.org>
References: <20260917003553.2465523-2-donggeunyoo.kernel@gmail.com> <20260917012420.101087-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FA3940006
X-Stat-Signature: yrc54bcpwwuq3un5htq5wpgmbrw4fekb
X-HE-Tag: 1789609124-368739
X-HE-Meta: U2FsdGVkX1/xLtX2RZ01SQ5FZ/70Avd4QBYJFTFA/SfyWoV1u2IzCyBwf9fU58S2TdFchXoLmX+/xG1Z67uimcspLHkhlj7a8xRJM6U7G3Qmv/mfV+3vKjBbDxGbqrdVhmPjpqGUb09y8TaCOQ0Nw9qmdQHT0L3Iicr9QsMg47IT/yrm9amMy0HTpkCA1HO8JWvge9KBv3KIZ3B/AYK79zOBqrQVStbBTehAvZVe/9DTAqT5zFhtUFWVY97+fwgL+4/fiL4slN/sPY0GkngBnoBA5lG5Yik/XxHhZWNUO8/QDSIF2eO8vlF2tpKiuGFin6TReYpDZOVTHg+y3ImrRuN8ABChs4gPeDpShiIe4Yw7HEPDXy6BIr/P6bfeHitAh0UXLlb+VZnrFF51SYzug7GL4xgoTNvH9iI2l1Hq9LEg+7l/K5J2yQJuoOqterAdTgHgVYywqaFZTJkWV06SFOjYNA6Sbmgt1ldrTkkcLH3+OqhGCYp7vx7biPYZ06qnSkP2NH+r1zIYNN6I5/SPw6/TmUlM7V9Pt8o/0QMjxE+ZXcumnetPVOPyonGwNyuAJa3h8QiSL1fsXO4lQn6t48ttcBRbWcbeXFctJK2WOblyz3YHf6GZVUfgU1MJxeOLLl4lzjub4m4UgYPFsTHeOMmw/b3iOe0n+EMB9+jOqhleSzKEG2BbUZvbLHDQNARbuBWi8EHXCrqKXdZC+qmvOWnYstpb1J8dKtw2nufFSe/yS+SvqzHfsYqALAaeK4W+aVR1k890vZnkJo80NhEMkY928tqCYQLColSvJ0bauwT+xJPJFekWqwOfbXs0R39GVzlXxSwUqMY1zBeTtDC713nGExgoI65PtzF5JCfOOj9J4VpQZ9051S+cl/sRBYuhvcB4lWZPWlSM1w0Vi0ggk7ZzR47fiUdsRGMmn0bTZzDDnrvGfz/Xrr4UW4rZ0MUOEkUVR2qBJDcsI3oq0fx
 1y6+FKk7
 Szzpj4XtN/bGnhqKOywATKb575Rhfly/TlMZJE4KVVFID3VGXgnHtG0+Jcu574vG/Eam91PW65qWwav2iHKCxKlYL7jgQLLSXqu043D9BxmcnvtA1IBFRZtrXwhuoen1VDJlMeP3+3zbvwrMqPQP748m1yWMUs7oGerA1Tvs4v61HZUVeMYZQIjdM89M6S+N4Mu80mvrabJ67+QOK9GNcePSwaplY8inU093Sx22RtsgnShhHFI5SaK9v3kpIJsXDYH8H4y6pR+tMiZkZnCiTr5TqW3IMq+6/i5BBVG4YAkOpzyxOcQrpwgEpfMF29Qk3ho/cBrwifM4N6iGiEj3ecqqWc9I0HB/Wgtj6GTwVsa58BTpygAIYajoDEG1TdTUtwzoNc00bjyIsYJeqPw/pX/TTZsX0j7pE2malBmrQivjBgFqHApRZrtnhKuNPyOkaRL43pk/gDzINJ9/mcnX18ix7/iiPBPXMsg7+Y377ZDf8beqX0wlepq3IEdGaUJEcBnzbIy+ymokJPiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 18:24:19 -0700, SJ Park wrote:
> The user impact is that DAMOS could work unexpectedly slow, due to
> over-charged quota.  Also DAMOS stat could be confusing.  No critical
> events such as crashes or leask happen.
>
> If above is not incorrect, I will add that to the commit message when I
> add this patch to damon/next tree.

That is correct, please add it.

The stale size is only ever arithmetic: damos_charge_quota() and
damos_update_stat() take it, and nothing dereferences or frees against
it, so there is no memory-safety consequence.

Thanks for the review.

