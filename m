Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684A5606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 19:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nCZLogSz
Received: by kanga.kvack.org (Postfix)
	id 5F1E56B0849; Tue, 24 Nov 2026 14:02:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2A16B084B; Tue, 24 Nov 2026 14:02:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491966B084C; Tue, 24 Nov 2026 14:02:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 054DA6B0849
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:02:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F556120C65
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:02:18 +0000 (UTC)
X-FDA: 85470933156.13.9BBC6D5
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7DC7E20002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:02:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nCZLogSz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795546936;
	b=RDbQ1hulFcWWrj3UnQEIIJkK0oA44fzFkprY9GI0r5eh5dysEejp6TsVjeX1sm0U1cu3Ns
	syZkgQia8VjVCusAOa+kefms57H3apjSjrZ+5F7+J95V1L60CVJGj2hogZou0sor3UBICf
	LoVeRCL4GEjjgmpqGKNRgALWptbAVXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmPlBJsxyoTZOO9g2mmGNuUfH7b/frSSah/ZWuzVmhc=;
	b=k1ReFTXRfOc9K/Z7y5MQKYvV6U18hxVgP7h9o69L1yd/qP1/UC/9FxWon9A853T1f4xTe5
	ZV/mQCqDlKhIlWmOOfluYKVX3qAo8lYUX2aCtN1wlBezrv1L5V1hDar0Um+TrlvZh7jdP6
	m/nyfd64aFnVxd+4EvinEnLzARpmwKU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nCZLogSz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8b68e59ab33so3504306b3a.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795546935; x=1796151735; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vmPlBJsxyoTZOO9g2mmGNuUfH7b/frSSah/ZWuzVmhc=;
        b=nCZLogSz/Z+RWs+DrpV8jSBdM2rr0eSnaGqqE6+xuVjl0xG+MJp/i3jPBRXd5OKp9S
         NrEVkFiJEoHbKw8pQK0qtwUK/AH1ldwVwViaw1ttGyowqpHyxlEg2A/EM1rLQ0LyFXPV
         bxN6/92hb4eiILKPxdkcQfbmSLtd3AlAEiLR9T2booVuu2mqF3Bn5PSJ5HVLhbMvy9Id
         aCtL7LcDp3PoKSP48L3jpv3XeBdIdjSXY1zc/6p6c64uXhjdWnezyQIyqMtM2RmAyNJQ
         o67FzoAPKkCdoaF5MmevOxUSO9VNxGhULE6rALgob20GaOOIieOvawMRfXcYX/cU+uvl
         CzeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795546935; x=1796151735;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vmPlBJsxyoTZOO9g2mmGNuUfH7b/frSSah/ZWuzVmhc=;
        b=JEYVxuc4aylqSbNMX980yr1uDnv5eOGRdou9k6R6xTdHcxxLws0aq93zQAp+tisdFE
         ZUhvTFLaCBN5IbWRiGSaEI2WLOa8iZFowfEl39lY5kwyHt6AqH0g/idGojkxSrnmDe1u
         wy5DDbnHqHUgAi/sf50xcNd361WEjqE5jL+Njor/tc+PXiA2DwiQlGU1ribqb+bjF2LV
         RLbJWeys0xtqWu7Xn2AXNFIypchVXqKksP7dBUZcTdbsksPbN8Ww0t0nkHMKL+xdadtI
         Ol08Kvx4UHmFmDqQLG8X974McF1rY7SUEynSnfhs6WVkANrpPNcZ/cffMPPb5397Wzhe
         Xy3w==
X-Forwarded-Encrypted: i=1; AL+hErFP44HI766WmFLEnTorSmZwjG7+bson1OB7cnWrv/4ycECiaW6IojIs2EjbX49BCrDf2ZcfZ1lq4Q==@kvack.org
X-Gm-Message-State: APuU4Z+Mfl3neKxQHiZnnJhEINk7d2RjSZWr8OU7vR/8DTkhWRso8stU
	ZfX8xaqE+caZvDHJU78tngoXc6KaE/92GsbZ74t1777X+S5BaR/QTsZAIuDFk1lY1w==
X-Gm-Gg: AZFdTZfr1vDjVzqds/vaPxsNE5NRaO3aWI3BRLNPpFjymBv+dXHNj1xDjEvvv+Xcl2b
	CgBHC6q+8KtcjTDmj03pYQhP5lDpkzQEkX4tk7jaXAqPTjdO1Qbe9vAC1SpHKKf0xzDAr7YYQim
	bpHBcAoDxaYiBfm/rjTZB9zr/darTz68Cq68EYbdzQSB+Rf/lFzY0cQhUlQkjbD1JSl9dWvQCvd
	eyspvZZE0zo9cYsgL4KyU1hDKbwFk40NyHg4rExWhUGAZk+0KogPqnLHUp72+XJpCT3tcjUr6qx
	9XD+HurXc2dKyEEsH2CgOeJPcwkyOJszgw6N8U1mCkuPKzWj9HPp+Y8lfga6/QExu/SI/UfCh1D
	PHHWY1z55ugd4/kbA1oL0x1/S/1uVb0Ya039QuxRZT+rjf9tjM3zVZwJ2qfaV/u0kbdHaI5B5KB
	zfeLgVNc1p8JszhmkeGU4k3Kp3Efkj22vMkmCIZ4hGodQsV0lMVsjqHROjpYm6aq6z5GWRd6BAm
	RmGsTtfP/2px3AgXfUZyb3Yh6Z0hrvpEfUZteHH/O1oAouchuqU7KI8omBelSiNGgFZofuZrFv4
	P35IHiIQYdkOZnQ/xE0mZrR30HgYWwuXlMLt+1S3S1uT/xRGqG13j8Y9NSUxLwNCPg==
X-Received: by 2002:a05:6a20:a11f:b0:3e9:f2d:d556 with SMTP id adf61e73a8af0-4014ca44d17mr16159174637.55.1795546934090;
        Tue, 24 Nov 2026 11:02:14 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde9bb05981sm2247135a12.26.2026.11.24.11.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 11:02:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2026 11:02:12 -0800
Message-Id: <DN3O9LHR4XNH.1EYLA6D1F0J2P@google.com>
Cc: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, <seanjc@google.com>, <jgg@nvidia.com>,
 <loganodell@google.com>, <arnd@arndb.de>, <dwmw2@infradead.org>,
 <baolu.lu@linux.intel.com>, "Bjorn Helgaas" <bhelgaas@google.com>,
 <oupton@kernel.org>, <alex@shazbot.org>, <gle.com@google.com>,
 <pbonzini@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <kevin.tian@intel.com>, <joro@8bytes.org>, <kvmarm@lists.linux.dev>,
 <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
 <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
 <linux-arm-kernel@lists.infradead.org>, <skhawaja@google.com>,
 <sagis@google.com>, <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-6-tarunsahu@google.com>
 <2vxzse0rzjdn.fsf@kernel.org> <DN2RQ7LGX224.3W3PSQ2PBHTJZ@google.com>
 <2vxz33sqz1xj.fsf@kernel.org>
In-Reply-To: <2vxz33sqz1xj.fsf@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DC7E20002
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: go31yjdfp37orwgm84dgcxf3iruim195
X-HE-Tag: 1795546936-355449
X-HE-Meta: U2FsdGVkX1+nXI8yLEv5OtFN2JpcPhhCM/BzIQWmMueiLSTFcq9NT86UrtMeRk+9LHa6dDkS8h3LWe/lUYaO01aagPre/im07WvRJ/9oE8t2AJk+9pVz1+oFQ2LJucGP5XphPj+Du5QzpEflBg1YpjQ4j0xtcX9Emc05HRIV5uzdq/pbm82kdXXoTfO8+VtJH8FeEjcIkAXM4C58/NCqeeouf1nK/ZvTeU3oP3ZZiqwZWjubvCbvaidw22kOleFThkpGkhdp14/NT94W4ISNiYyq1YHPtAmGiHyuP5+8SyWuM+BV3BEtTzB1rM7W9tkVc6DIMd59UHOQPUKfGw8hoYpGiiUKzd/HLkJ06M8KWl1J07U5Vbv2sb5BkMgYjD6OgKnnsbqGUX6XczGmu/Z0xzGYVW2XeO/4LVwToQFm8Z+ywLOv4xYZjAp7dW3/9Or9NfDgTzSD90FfivkeMb4nkpw+XfU2yNxHtJCg8k441tOOX+19RXTcg3OHMltfw/Fe7+s4DrICG4jhLNbfup0PfTEqy0YfhqBZsQ7pRg1sm7daJD2H6NtJujHITwMB1dUeNuuHiTX/9ZD5XW2yjqh8t2M2wfD1zP+/+hqf94Znz8k6kMjJzVMRJrABHNOwUfiSAKB3M6IeUBIIyxPvwmIzSx6alMgInsPGd9bSwW6vVAe6CTR+rt41ayrYTTj1RmQqeF6RmFsmycB+2b11qbgGkXvMH8km0mGPbPrh9AaGz1IaM13wOtiK90IK7UOFkPpDecsqF+w5jI54p3fIkBzKwAGd+bB71g7852bXQt7hjOeGLjCisjZePqvHHesdD7qbht/L9sfwqawhLUKlXN0qtQSYtLfisbA/+nAN8GhJO0q5nO+00arfnvhKY9TFNYwaCK3gjXVagTA5jz98JfBvnMKBFbSzPs1V7Hw+2FW1ErtYPFEyLI88dzrGiGLVrrMmT3VuQZirzAKyQ4pysH6
 LyI4gyRx
 6oHl6h/e5BRENZHLGbJGO8zJDqiln8c2oL7vhys5kJVBUQAswnj6lKzheBm+xsxg5hy7Fb/aFwtMy7AWMHq3aUQIllt/e+BJO62JLfcaugdFolxXoiJRdXoz4fKQomCyhu1dxHy/mfuFsleKhzcKigdmZZEL38xU/PC/Virq9bee45JkyyvD3YAb0iRU1D/6Ol5pmEuVbdj1BBdq8CvnYGSenHm3Q6sDzp+Zik5ftN9Lh7x/EnTJ1Pq0gVbe3gdMPaO/XuXYgvNe7j16MS4ZSHtir1dY6g0gC0AWZqFwri5eB0VGVltHPUHs8/nB0ILCiVY/AOVebL5rxDNeuULie+jIVAvCEzD3pfq0N/Iq25wMiOY4Z6Pso1rHE1Z8feRDiar/24lgabPogJ/qB/6ZC0+RGIrpmJI4TK1IN+wwBf/HOlq/BdVMjvi5ciMo4E9Y0ddZs5Xhuyzbbq7exPL425F6zjvm0I9E2EmN7tQxkiU+4sKQP3NhpSIpuesvLbc79rxgya/D67B41EWey5hfcY02uq+WPSIb3vdjdWgBsufVZ2fvl587EzjoDUXi7l3Fnph25b+q9Sv/PlDG2CbVeozQy/5jGoztACt15Hy2BtrVdjYJk07xt9Szl1ZC0EckUSwHs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 24, 2026 at 7:25 AM PST, Pratyush Yadav wrote:
> I don't think it buys us any functionality. It just hides the problem in
> some lucky cases.

Following up on our offline discussion: I think it's worth keeping
support for optional features, both before and after the spec changes
land.

Before the spec lands, optional features are the only way to enable new
features at all. For example, the PCI follow-up series [1] preserves
BARs and bridge windows using an optional flag. It's purely additive: a
kernel that doesn't understand it keeps behaving the way it does today.
With optional features it can be enabled as soon as it lands, and Live
Update keeps working in both directions, including rollback. If every
feature is required, there is no way to enable it until the outgoing
kernel can learn what its target supports.

After the spec lands, optional features are still useful, and at worst
harmless:

 - Kernels that predate the spec mechanism can't provide a spec. As long
   as one of them is a possible target (e.g. for rollback), optional
   features are still the only features the outgoing kernel can use.

 - The outgoing kernel doesn't need to consult the spec for optional
   features at all (less complexity), since by definition the target can
   ignore them. It can always produce the same payload, and only
   required features need to be gated on what the target supports.

 - Nothing prevents an outgoing kernel that has a spec from choosing not
   to set optional bits its target doesn't understand, if we ever want
   that.

The cost of keeping them is negligible in the current design: the same
number of bits in the header, and one range check on the incoming side.

The one rule we need is that optional really means safe to ignore, e.g.
optional data must not reference preserved memory or carry restrictions
that the next kernel has to act on. Anything like that must be a
required feature.

[1] https://lore.kernel.org/linux-pci/20261019213054.3157159-5-dmatlack@goo=
gle.com/


