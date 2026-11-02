Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94BA4606A33F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=tZFtirQu;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=cEFl4VX9
Received: by kanga.kvack.org (Postfix)
	id BB8F06B05C3; Mon,  2 Nov 2026 17:54:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8FE76B05C4; Mon,  2 Nov 2026 17:54:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57F36B05C5; Mon,  2 Nov 2026 17:54:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85DDC6B05C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:54:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0975914029A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:40 +0000 (UTC)
X-FDA: 85391685120.23.E43225C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8BBBD1C0008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=tZFtirQu;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=cEFl4VX9;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660077;
	b=uGBJrGYGuQMWFCJ45PiYzM6TaRXjZ77s1xaJLcZB4jq/TUlcFXpBjJTebSanq3cczGgiv/
	DnUmJr5CYKnoQPZKm/dcfsPGv6aCAww3temlCYG7E3yfB5GGulRiD9Gf9cuhWhN5kG9VoR
	S1gOU+wtXWsDiqI/P1ovebThzPHlXEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvhSK4+erTYH8YIOH2eSd/nyRcOBtvC7PXAApDZRJSQ=;
	b=lcxkI85+U1IXNQXs1vo3maX2ki5O67SExM9PKOaiZneV8LHEtMnHxhgB+NwrpuJl7nl7ro
	qzCkbxyXfzK9GQJBqjRadKX+yjqvGFnCrUigaekSfNrKZPg1FxzY+MjU+YrAtiRdhWZ6Uk
	DoE0HvqaeLPftT/RzeO3LVXP6hUYIX8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=tZFtirQu;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=cEFl4VX9;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2LYlQ93301064
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 17:54:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=JvhS
	K4+erTYH8YIOH2eSd/nyRcOBtvC7PXAApDZRJSQ=; b=tZFtirQuExq31bYlA6vL
	pcvRyF8+kFc7DPxZsbDjjVFgCknrsQOJ/YCBOg+i7kcmQ4pSW9ycDbX4aOgqRPoK
	TOpazxssr4ws8ECg2S7X5BcJ7dpEhbBe3dvvzcpylWIXTAkGgDJzLD3R0R3Gr13I
	v11zHaRvIy1hTqr1fuQi/zEqsp8tYbR+X0xVKWWcVDJ0W4pdrwDwQ0y5SscjjGBx
	P2ynUjNatgKSyne0N8PGs7LQrUfCinK336Bpq0UKtl9zWm0JoT6ESwOb4RLv+Pnx
	RtCjB+ybb3yOr2V3vsMkR4zzlAiM7box6zZFrI0IdKtvjsiOZlqjQpigynDbKrKj
	5w==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hpwa6v7h7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:54:36 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93caf6c528aso506675085a.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793660076; x=1794264876; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JvhSK4+erTYH8YIOH2eSd/nyRcOBtvC7PXAApDZRJSQ=;
        b=cEFl4VX9pkTN4UpJeETW5kJhHsKjt95sRLFDmOkKFYjnIJAHf9x6QqysR4c2OJgq2P
         PiwW/xpdxd1MdhmWK/lUlFRI/1OoTamkdVVmFkp9ES8kJC7GXk1deIeW8cku+qFcB6+I
         bYGsgMjEyCF3O1C/Q5ENffdD7DeTSRGnASDQmFKls474YLX6yQg7aJsi+kiILATDc35v
         QvgTNJG56SIvstl57SO42//g/Rbvq6Qp0d90AC7+Z1Y+if0YJgW+AqoibOVkL4Ew6WJi
         YPAXRESJ7KWGIVtATMORL+wxOxfl5Ks+5zCNntJch3dg+ZQI7VB/otTlyZgOiMK6N8G9
         MszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793660076; x=1794264876;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JvhSK4+erTYH8YIOH2eSd/nyRcOBtvC7PXAApDZRJSQ=;
        b=rjEKj26WWAI4EOp2aiI3nSs3Z5dB9vlcpn2O1SKlEWim6FG75MKW+0eVOGb7ltaBoM
         jD3g3Vj8mQYv73EixoWQbcE+p4cyw+bWiGCSYsESArAiIhoodz+1WP5NRsOlynSRSZaa
         H1LVrSkcssHNvNHgOpRS6woN2K2wSblzpoVjrDRqb0MVre+w3ioqKSRxeiWXfYEpX3Z4
         Bv6b5efJDbRSM/MDtnQdEwRlHp34b6LqLyUAaOD9u1QOEOwKyy3CNxOdZnjAe9R4aOTp
         NUsft+mr6OYUrEoVfMzysoseezHHOLPeLrQggvCmpylwqnZ36H7Aby28h7DMhc5AQhqW
         7ibw==
X-Forwarded-Encrypted: i=1; AKwUvBzuA8wGmq7agX5hBlddv9CVbTjz+pc2wAACs8Dl0HBlBsU7qsE7pBbGiI+v2L0B73y1+rFDW4PXhA==@kvack.org
X-Gm-Message-State: AFq9FYI16cE/4Bg1JROB5PNrcT2ONKl8ubvFVlQonzOxJ++iLPfdtHEl
	mYPBknRobB3ZE4hw06n+x5ejpRrhQUkq6wBXudmsZikwH0ArgtUwDLb50oRDCwb5BH1/wfReA4f
	gJ7HjT1nksce4SaUMOMdYEdbQ7LZawBQrsPmczhWRin9A9kbn
X-Gm-Gg: AYBFou292AJzDDhI5oUaua9BvW3NOj+1b96AL7cXAq1uq/fUUuddAXvdcC8vCMptqab
	VEgLheElxWdzCcHaHrP2jaN8ApC4jhCOOeg1nGZFoMFK70i2UZNVf9aHeNVNa50AD+mES6OCjrG
	H5ASiJhB9OhVvE2MroyTB2FuojO/dZuKUnrImnQVumOMIBG/xUzhFCc52o6mYlFyVxLrDwL4UD3
	W9al1+s6gNoDggSGxYF3SJTkhbuo0Oyu5hjuaQoTfaAGFwXgQTUkzHrOdvO2LAAkj3joEJrjLaI
	g7pLRtxQxbizRbr7VChBwremB0EQEPzN43eGWyTs8B1rAYawJNFDG26xK/EwsYqE4vFt++4O2E/
	Nw2ed1F3wHxvOHvIOTsBMJDar78oSkACLaVjljVNbiGaMbiFSSuklHlG4grE=
X-Received: by 2002:a05:620a:4686:b0:939:feaa:949c with SMTP id af79cd13be357-944216bc9f1mr1945417185a.36.1793660075998;
        Mon, 02 Nov 2026 14:54:35 -0800 (PST)
X-Received: by 2002:a05:620a:4686:b0:939:feaa:949c with SMTP id af79cd13be357-944216bc9f1mr1945412485a.36.1793660075493;
        Mon, 02 Nov 2026 14:54:35 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm24710529f8f.31.2026.11.02.14.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:54:34 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 02 Nov 2026 17:54:09 -0500
Subject: [PATCH 4/8] mm: remove attach_page_private() and
 detach_page_private()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-page-wrappers-v1-4-e7280bdb31f6@columbia.edu>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793660051; l=863;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Bq8LYY+n/Ay+89r1G5Eo/k9gxFa6AOfJWAM1sU3Jypo=;
 b=hGYmgc8vvXeTe54e3g23M49eW7JIDcFpSj7RhwWomEDSjn+AGWW8KxWJXr1BemK/D3QZZh6pI
 hS1h5YT70HrBFbsaj1666ot45sEpLJeSQSECMF3m1N/8eaO5Uud1KEC
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfXzi7yJJnzm9XO
 hClMpkkmFRmIz0cWnekihD4u9ddpBut1FAob+LpkTehr0/061LtHw8uue8Dp7A5KyO7w/YlV5rx
 xCyBKw40oQa7XFISv+eI/WyYtdWgjDEpCGQ3dEOzf2DM6sxLRmthscTEYtS2G7zHChxKVyNwhIu
 5TGWFE+GWLUjY+AdYOFa7WLVPdKE5wAAuJqLkzqvU5nnUwV0iMaPS6fI5nqJI5TUEq2lupgmbIt
 iyWOu5frBCX4wZQpcG9BwWQq3Yy92N70AtxbJ4ynbP7ahliU5GcNY4fMt5j61YN64ak5xoTNmC4
 2GTyrkQcHXgiOwcNWWfYW46dsHCTRWcCHvKg/WXLbJB39jqGoybUbpNZugsCGz3VWOwXXpmX4hr
 4a0/ObYTyMEKxGfxvFyD0YSLJFzPDViwkrdjbXxRbTlxfKKdYBjWRWlzLpS7JGqiEC3FGSJ05xm
 JrIt+m7OVclXorAfNfg==
X-Proofpoint-ORIG-GUID: -rJPMZSz9t-_rkY8WVdYRTYgR8RCvePp
X-Proofpoint-GUID: -rJPMZSz9t-_rkY8WVdYRTYgR8RCvePp
X-Authority-Analysis: v=2.4 cv=JImuIMKb c=1 sm=1 tr=0 ts=6ae914ac cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=utpKXwlFHvWpKPHLcNIA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfXyj7C1ozV7eJA
 ZOykHoGAew6JDtT5nQlv+8INX2oSPNORt85JqFPYLSyaarkQC3TlKyU2DlZPA4UWWlPbOg5UhGn
 EXkYsk5rRBgUP2b6hQzQv2A4UdA6OGEsvR9IW0++7TEatDdzfkT9
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=10 clxscore=1015 phishscore=0 lowpriorityscore=10
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020090
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: ktfwtb8oh65bmxbjod5zys71p356t48r
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8BBBD1C0008
X-HE-Tag: 1793660077-579812
X-HE-Meta: U2FsdGVkX1/2E51fTXXtkovZWERSFswGQdfbF4UN84xezB2kZbyfQPZbWwEQE5ETtwY1K7xaDNEkNzag5GsjLtb1q21mDMbwzsNgZfEx+s75J3bMggp8lRsuwOT0TzsZvus86G4SxjWp8dtT2H98J7Pg9kZGHSIBX3oDYPTNZ6lAgxSmRUziN8EXiUUwLLnUVqFgFw8TgwUsGWKrK7beft+jChWTvzCSsisYWe8tFCMRRIW5YcQtLU2OrF1AYQ6ER2CoGPKykIKHBgdfPrBUhKBE4X+I+ZO94KZVg6NoglGWaqP2oIv6ze3dLcuhlfOTahkUCXeufXojk4N2ejFbHbwbdLf2Zj1e0O921i2VESoJlhyfmYuEpjp//9rzWoHrkQ5eV2feyeuJx5+QxLCr/1y8D+eaEy74cz+5i9iPMbHaq+OSzuTBVDJa18hNLzyKyACxyETSHGZUg1DUnTirObXPNOolIEyRyc865hcQJAHII+AWDclhsHpHVwXo6EeUEnINBfgaNtE/ZIacwEWe48Atf5/dfdoNOJlNCm+qZk0nr+qK7x228N3b9c1U83wNAqIiaNrBLPHn4gSSLwVP7GKE88eWTS99QzvOCDN8GfPmkpB417yeKvk5sCn8d0vGUjZhnEHxo7GJ17RhAaDoXSlAWunHAhCPgesBmJcoigRAd4yqVwyxQNcd/qO2tTX6ed+ynHPbptF3MyH63gGplkk8wl4j14PQREKbjhC0OFwx+/midkqTw957BOzdTF7f2QK1qhOUFJqjot0lprLz5gen6vxqlrxF4DdyOJcGoenliZTCvD/86M/KeuXGVCKyJM4+rmbLr6ZFTZeuvUWN6m/hR9WUdNeq03IGuXTIa3nL918W0QZ0yeKYcCrXCpsCzyrcUp/0+HbXGLyYfmtrkTZHTDz61Z3BbDa4wH0zCV4xy4Nv7Rf0jhmTU7KjjkIppf/HDje1G3MS+FT9+oH
 2T2Ju6ZR
 4CsR0R7XUy2XxbwB3UZOcUaiU1hHlrwY3LtxRdoKDfOPs+mG11o7TNdd6YOaserHE2uD5wmUUw70D/cC9X0mx1QKFdjyYyVHtJO7aDHLIL2aXGYzsRR4gAlBHpzA42qEZ4zLWFHeVrkhrPyyLMpSC7g4uDG41HUZt2Q8azYl20VQUoW/vZeRhuJ46PYCdJGq/0KIvFAf+NP4rG1MyxfRQAighewrb8K/W5VO8dFf4tIIHvL0Q+dgkJBKi8GaFv8T8w/usDbNGh/OcABmQIwSdk1bpfOPHyUccj480dz4Hl24cNoaGA4d7vK+METn3r/DzGdtPTXqbg6IN6RGmPbBngogol6vQXS8p+AHF8qQ8e86ABkEoTTqsVlqdg0OeOWt52C7o5FJ2crDtQgz0aH/QklpYbZ0xtSsBEAoEJqvYsv8M+RkF5pvV51pmyFHIRK2BayBeRQv9kx5rCP803MhAo/qU3n7YCLPaIsQ+yYTbwtiM9pnxmwmSirV14POMwy8hxqDp+6o1t9n9QtCnSQzV+nfwP6lylDPyWXci
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are no callers left of either wrapper. Remove them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 9adfeae2153c..37b7786350c5 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -635,16 +635,6 @@ static inline void *folio_detach_private(struct folio *folio)
 	return data;
 }
 
-static inline void attach_page_private(struct page *page, void *data)
-{
-	folio_attach_private(page_folio(page), data);
-}
-
-static inline void *detach_page_private(struct page *page)
-{
-	return folio_detach_private(page_folio(page));
-}
-
 #ifdef CONFIG_NUMA
 struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *policy);

-- 
2.39.5


