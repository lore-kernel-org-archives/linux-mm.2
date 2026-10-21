Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C532606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=whvLB52o
Received: by kanga.kvack.org (Postfix)
	id 759B66B07E3; Wed, 21 Oct 2026 19:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AE26B07E4; Wed, 21 Oct 2026 19:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9B16B07E5; Wed, 21 Oct 2026 19:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1BA6B07E3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:02:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96F29A0693
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:02:23 +0000 (UTC)
X-FDA: 85348158966.27.6EA57D1
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id B5D0BC0009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:02:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=whvLB52o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rh1ct0ynFCJmpIeBgUsQvZu9SOoIsv6E2A9BdvVwioc=;
	b=GHldD+wK3NzURIk99vplSuooObdaU2f1jIMXKBjSiwkovfipuZ/6I7cnosRewH2AcKi3YO
	zB1aXOM7hS0nLBjXxkAyX3hz7z1gVux0vsQhvnIeuTnJSbl7lN93jhr68VTBDFqYCRib5j
	42ZdS50NonEbPCuRLOMIh5XqKn9cJxw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=whvLB52o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792623741;
	b=j4bPxK0gyomqUAOSY/BDElkEYG63kekvRq6gqGPeh4dl4hjKQTW5WDgObjQQZTmj31BGDt
	/dHRLst4Prnx3rcCGi84aUT3s0kywDttj9dpNJbqRkJZ9NJpcAE2UVmEvf04FoTDqPSO+U
	UoqLWfEXGPKJe8HFOs66YDTJe/PsNQc=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso766548a91.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792623740; x=1793228540; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rh1ct0ynFCJmpIeBgUsQvZu9SOoIsv6E2A9BdvVwioc=;
        b=whvLB52oiOOtSQql5RL89pq5sgLTZZ5p24RPvHYGXouUgJJsMFU1zw1RyXp8KjuPu3
         usenShgOgy4N5OiPtIfOgFp/BdQR8/ks5aJW0nRqCW2O+RrfccLq5/8Opo1vsa1obICh
         YAqjGoqAITROb0CGtWn6V5vxbnDRjna3jxykYU0wxEife/gMkGH5sfVjz2XvmTvFjwzq
         a4CyplfK2uylucMyOeTCNOL0JgR9pT0XbyA+NDNVIdKMyIIEDViWnCTpx5S29LUvx5Vd
         H/N9ZzazxLK0RgKdqSn6PBrTiGFuYopRjnR2SVOaSaaGDALOq6eYcdaFhq9A9ybJdZC1
         iHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623740; x=1793228540;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Rh1ct0ynFCJmpIeBgUsQvZu9SOoIsv6E2A9BdvVwioc=;
        b=wHt6BaLH2OsP6okbITLhrRzAkITUI8wXDGVVV2dA+/qpHIvCgyk2I1QhTFev2ji6UI
         xo80M2Jh0XYtDck685eOj98YouTd0XeTN586HhIdxX9h9ySTUhy/p/HB1F+Tw8ptBRIA
         Yxbz0bvWHr6j+eBw4gVh6kkl0a56hPw8JMZKbV12+qeO2sXH9KrPvOErxv8j1Xla4tYU
         sNFCTlHh3M68avQOPmRkgXwvvUIHGeJwPIiOORnIIB7pJqFjv5N1iAX04YTXjZSsH75x
         9u5SdcplfBOoIia6zn+zrXN/2H5JWWVJ7F6bA5mUhs4RKWPhViIEtJcLgeFeg4QFPTYG
         06nw==
X-Forwarded-Encrypted: i=1; AKwUvByULHGZxJNDMI2dKjgCQdqaGr6sDI744i810xeTOXBWU2CggJrSy8bPU3QRliPgqAVbA5aeqnm1Rw==@kvack.org
X-Gm-Message-State: AFq9FYL0Fg6Eq7tjc+8ClvjEE7QHaHWvfaWi2/LwgInR7lHr4VVXAR9q
	vHNE9DkD79c/wA6IO9st6bXZUTkpMDXbhb2IlBSuRLt/Lavd1o14+bLJYpfptXoNOw==
X-Gm-Gg: AYBFou2SB4Sq/RFIKH/VrqDd0hdaLrJlpkr5+AEdIHF1lLcKzZuVACNaPgK1uP2l5n8
	or8MdQSY0SmeYwVei/FErQUA8vhvJ9ikfiKii9oQ/M5rP4nGiC9Uj63Ts6Xgve+ajEfeYaJKQWI
	TPK4hFTiow+46JHiGDYuRcyolxMmaafPPzJt368eR0u9w47bAuWSxTj/9bEAoM+4C0UqMoLyNU6
	YGzvoksNmNoZSZwX5p4qhQXgw1c2no8ol6EPKrJy6HY7h7GLuElgs7lxyHmMM4a/pYuGrL3ftaZ
	cJI36Wb8NViTylwc8ndB9ZidgDR0WCL448sWqurpEyojmkFK9S9ujxZ3LHR+M1434pXxNiYyQhK
	7YCAiCs6Uy28wTypJJGqxxMTJAjTQnuLueq6EwR0io06ytPMO4uamTPuFq6UaVH/t9hIJalRdSe
	7n3g6fpTzslTagSK5N/UY2KqkITJ/8kNRjnfZie0JBRp7LPLIRYabbyFweR6scDoMuxqZ1NDuIt
	h3jnNMwvtselvihj/+u4rgpmClfin5ahc60jabS9EjkfuRuFJyWRDA20a9rbirMwiha0DZs86Nm
	h15l6ap4vbaSR4IQLKvhSneEnFyl171DZQDTZw==
X-Received: by 2002:a17:90b:2f85:b0:3ac:7c4d:8be6 with SMTP id 98e67ed59e1d1-3ad86d9e088mr2829501a91.40.1792623739843;
        Wed, 21 Oct 2026 16:02:19 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4896c4dsm1314919a91.7.2026.10.21.16.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:02:18 -0700 (PDT)
Date: Wed, 21 Oct 2026 23:02:14 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tarun Sahu <tarunsahu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in
 the preserve ioctl
Message-ID: <atlEdhPjlyTPDWmG@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-3-tarunsahu@google.com>
 <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com>
X-Rspamd-Queue-Id: B5D0BC0009
X-Rspam-User: 
X-Stat-Signature: 7kthrzjxm8b14qfeaypsqbced5jtcrx8
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792623741-782811
X-HE-Meta: U2FsdGVkX18Um162YaYIXwQO4hS0pTv0Y/oAyL8dbxRXNfYQy5Ztv+sGDFNXU2/Oal4tB056+KXOGHY2UVq6a4M1wjC042u96nBndFBUv7YS6TyUdjE8fyED4U+Crq+68F5FYf+WzaWi6o27ce3i3fukOgJ4FfDG4Ktq1RuNorCpxwjHmXK5MBxae1phIgtV0Qkiyd0PqnluAuKTrm2cc2Om2nmVa14CBrd+syhmCzV+PTOjJIDINOn0ehuqO9PwaxXZbs4Z7dZNdI5yCiA47xrL7ViBvam/+fFlJ+msW5kgAu38dCGjCW5tEGvP1KbHl3Ja4Ly1qO1//oZboPrX714vvusOi21zqG2zgr58ImDa6mfRhkqiLXFkq547brxP2LH3hUGmTo4fDnsWNuS//9U5raYmvnACbHwve1cfGNc351ZWZEWfxdKhZk4UbPRjdlfmnIiSGzdfs+3NMe7ybdMZnDKqiet42cOjW7p8E9uIN7PxGjszsplct6mfkS6WqCWrVPvPtK94fiPTNODbJa99IGv/riCMynXSw1U6R8J1vQMWLEoSCxjhEPqoPF9FrZ3Ll1IGYnb7CelP1dn3GDV4H73zf0NzERJvT/qkyHdQRUL2JkC46VP4xUdQGgrKVPyUkkh/z9IqVvHMQ80gmaycjyzMVkHwvKxbPFtCfWYAMA0pb1FaI/Xjdep+4qNpGkWNicbO6pmv3aLB2tHvb32dWaIzpKrpY+rCVKZW8pMIC228XqlXUkan553KlHzrC2o0TIf4PtnFynNiuchN5aerAuVdeD0djQFsveSebgIFgMERHsyzKXgFUAkfl2jqRjM2H81PA1+HmuOgCSAZF2lasRCXUyUpWvbcF/dCIARh6uzhIogq5InJDd07oKbRleM7HhIwDpO+PO8KXooDFHCFhoJ8SNH7F5K43ZlSKfWjRwcPijsbST8GIXKOSz2Yjzj7OZjPoDupQNAIIU1
 dmXae1Ih
 al6eTYnJA6+B59/9k/9MNiXJrK5UkAYFJ7gushEPtL+mUTGNQuGb11wvDrleyphvuwWKwwwL0ZvaFwU8UxFy/igNMjiZ3UyYjiHk8NBPWVPptH67nrAWkdyudR7avUG+hQk8h7jLerqir9xPh7Kg2+cXmuI5Svy2eSiClXvWVbKPEVaZ6dQ05DpYxp9wISuA5T1vnZ/OoB2gTJ+e90qyEeXAlYtsizVjEKqDDtDDVc1inwbp6Of9ty2Z8uo2aqgPWj+PzoBb+eAbIXclN6LScvBmfH9otm1xO8lTVXlcD6BojIufzJX4Ne4dPtA4TpCoP37jmzeDKqlhsREAQfhWoUCo/eVkEbMvs0qy6UjgpZn2tevYu1gMrEg93LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-21 01:17 PM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> >
> > Currently luo_preserve_file() iterates over luo_file_handler_list and
> > picks the first registered handler whose .can_preserve() callback
> > returns true. When a subsystem introduces a new, backwards-incompatible
> > file handler alongside an existing one for the same file type, userspace
> > has no way to choose which handler preserves a file descriptor, nor can
> > the kernel keep the existing rollback-safe handler as the default while
> > allowing callers to opt into the new handler.
> 
> That is not how it will work. If we are in the .can_preserve() call,
> it means the user has already decided which file handlers to use. We
> need to do that before any preservation happens; otherwise, we could
> run into conflicts on FLBs i.e. FH of different version require
> different FLBs.
> 
> Therefore, there should be a luoctl call (i.e via a new ioctl to set
> compatability) that provides the kernel with the specs file of the
> target kernel we are updating to, allowing the kernel to select the
> compatible file handlers. Since .can_preserve() is called when the
> user is already preserving files, the specification must have already
> been supplied, or the kernel should fall back to using the default
> (i.e., latest) file handlers.

I don't think that is the right direction. IMO the kernel should not be
choosing which file handler to use, userspace should be. If userspace
gets it wrong and chooses a file handler the next kernel does not
support, that's on them.

The problem with the kernel making a decision about file handlers is
then userspace does not know what arguments to pass in. We are adding
custom per-file handler arguments to PRESERVE_FD and RETRIEVE_FD. If the
kernel is picking which file handler to use, say for a memfd, then
userspace doesn't know which arguments to pass in.

Sure you could add some method where userspace could query which file
handlers are active and decide arguments based on that. But it feels
backwards.

I think a much cleaner solution is that userspace chooses file handler
during PRESERVE_FD. I would even require it for RETRIEVE_FD so that we
are guaranteed that the args the user is passing in are being sent to
the right file handler. Passing to RETRIEVE_FD also opens the door to
transforming across Live Update (similar to how AWS did LU from Xen to
KVM as discussed at LPC).

Regarding FLB conflicts, today we don't support multiple FLBs for the
same global state, so there is nothing to conflict. Selecting a file
handler during PRESERVE_FD doesn't change that.

If we ever need to support multiple FLBs for the same global state
(e.g. an incompatible change to the PCI FLB), we can add an ioctl that
lets userspace select which FLB to use before preserving any files.
After that, only file handlers registered with the selected FLB can be
used to preserve files. PRESERVE_FD with any other file handler fails.

That keeps the FLB decision up front and global, like you want, while
still letting userspace pick the file handler for each fd. I'd also
expect this to be rare, since FLB serialized state can use the same
feature flags as everything else in this series.

