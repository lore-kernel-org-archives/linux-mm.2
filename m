Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F83FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF98C6B008A; Tue, 28 Apr 2026 09:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0CF6B0093; Tue, 28 Apr 2026 09:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0DEC6B0096; Tue, 28 Apr 2026 09:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 914DE6B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:18:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 498FD86FCA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:18:00 +0000 (UTC)
X-FDA: 84708017520.14.E193E08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97B23140009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:17:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Et14bSAB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777382278; a=rsa-sha256;
	cv=none;
	b=qTmtKc2ZrGLgbw6ZlPir2610NeDIBMQuaa46xZv3r8EAXJt9sjWbyBpioVarg9mIpztD6i
	ZJskJgqPgooZ4iyQgHPGSK5YYLn9bdg1vPKpqY/QSU+bFZALFwN5bu8YenPZv65+wRqVl3
	UWeeMIUMPkwVkLkAgs3okwrnvc5ERwY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Et14bSAB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777382278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwJsUZuQEfnbiJ4PSO8F5D48hRBd/OtXtSTea26CRzs=;
	b=eXxSDBb/qrKFcMMf/w7+q+SVkLv0cnBTLGtECNITP8X8BOVdRYNR4Kqb6GEu6xudJ0lid1
	ORwL90q7KLWLZrVWPT62EEUNmDQSLI6w+6CjiQnwv0ro6d0jS4rjmBMYPd857MdjQ7zwJp
	xIZdu+YuP5KVj9HfX3NtEmGd07SJLc4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB76261119;
	Tue, 28 Apr 2026 13:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81192C2BCB7;
	Tue, 28 Apr 2026 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777382277;
	bh=qwf4EHuzt7QWo92n3l8Ao6eD0JUFXLkqW3rvrM+bLGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et14bSABh5ySZ8yuOioeRNFH3wAvM5Kvw4tCL62WlhkTS/OGXQSYwmJ5Dq9ZEt7ac
	 R5trj+BIGdBpT6kSCAcM1DARqqqW83QhKKP42LwLdDKhoL8/TwDBHTOkqmRQA9Z2BL
	 K1pjj7avUcYiukEhDtTE0w19t46q1z4hEZHlE99KMNqMnTpgyF+MkkVdUsGwY+abNe
	 mUNQbM2RTDMo1m0axSkV85w5UMaQ1uBC0TjbBcOGNqG6lHtY4vlzqreA40ZbiRurO0
	 tMnMnZPj+VZ7SEe8w7ekQakzPt14tC3Q46iCBbQzo6xFncdJCKl6BQUYvaLuIAqFf4
	 +LWduvCuZfokg==
From: Mike Rapoport <rppt@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Evangelos Petrongonas <epetron@amazon.de>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	nh-open-source@amazon.com,
	Saravana Kannan <saravanak@kernel.org>
Subject: Re: [PATCH v2] kho: skip KHO for crash kernel
Date: Tue, 28 Apr 2026 16:17:31 +0300
Message-ID: <177738223126.1904167.3186811087427171016.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410011609.1103-1-epetron@amazon.de>
References: <20260410011609.1103-1-epetron@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: khs9s4pgsiji5c33xqrdw5jhkt4sdynu
X-Rspam-User: 
X-Rspamd-Queue-Id: 97B23140009
X-Rspamd-Server: rspam07
X-HE-Tag: 1777382278-189841
X-HE-Meta: U2FsdGVkX18FZol8PZGO4OxcTKpkhuXtl8MAt+oX8hBubYNjJupYVn+74r/dCHpjDqh1VAkeNOkaup/BkyaIZpw1QWD6Hy0fvELP63NKfpqdAswys7yWyDi8r7FvqvFBZuvCCWF8A5WIM3RivqY8u3z4UmGeLh0cZZnHI/n2ysPYJV7CvPD5YBpAJLZGvaKirrWkdfiFu0yCBGVgtIN2FsKORl4F61YZODi5XHxD6wNykc6FHXy35DRhqn5DwgQlomYNZh0NOkh2Rhd61bhvi69rRXp8z09e/HW0l0lgLIGnRpQh5mAfjg0ucpeyTA8IVqz920hWHMuGvBWq8Z15R4Ay4aTgSIKPN8cH/FM2V+F1hDcsh7OyxUOO2zTgmRq3TiSNEtua5vvZpp7mAsm6o+k5Yu5DDX2GtkCm9PjVQ4O+/GdnbVnW+t/9JHejhRjeU1U8sD9ND7eoJi8aKYvOk0+r8mf8uu+TqhGxs+ugeBW4Ar+qRBAM4wRdxJO2D/PCL4QZU/wQozLvMYnUyVut3r8mcCSnszkldmIh7ibabzCK/5gZoAVpBspQ0f0Zt4SzwdpNbGNInLtGOU9ft1UdSNSZrKcI0FjVtD1ylqgD27lPQo/GqiUp/AuX38F7wrklQ7+QLM5+Lj//+unozkZ+bO4BhwSrpYbNDQshxmsx1Fjwj1SgqGfA5ahO1oE/wJPSfauTfbL4kJ8gsLhXHNcc7ldT6pYNK3jtn0wD3LK836bCNBtlK4+DpTimIPext1+K7Qrp9eISKhbPYjiYEXKZ552O/AEnxX32CF28lY4cU48uEXF6itbRhw9jaQj+p9IDm8f8zaFcbjPVIx1lOIMaLHAUlPu8xbCXpKdW/Ud+uFf0lGd/w6fbYNCXDWvEQ7YygVj3/Aqhb+3z2B9ylCx5aX9IRj0FiQ1i1FcoXvC0CQHK+lC5ocpF1g3XIs0vWPsPoMRAqT13wAnhCBDqfuK
 KYPo1RGv
 nvD3pJzZ+B8THgUzaqMgT6DcAIfJtSKNRAussITe5O+siHQqJQqrqgEfzpfxTDpnwwsQIcTSWSHAjynDqs5qGRYx/4q/nN/A9xZYSbpNHJ4rcB+roCe+Pu00GZ7toSnm5uwWM3g/exXnyyp7QRvqzZDPYbsHO+Gu9DOPezkx90Uf2m5s45qsqvR/0RIHn+TLxvWaOUFuKQe5R33kKi38L1Au69fiMoNYZYecIYANQL1MvopjjdFvoiO1/PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Fri, 10 Apr 2026 01:16:05 +0000, Evangelos Petrongonas wrote:
> kho_fill_kimage() unconditionally populates the kimage with KHO
> metadata for every kexec image type. When the image is a crash kernel,
> this can be problematic as the crash kernel can run in a small reserved
> region and the KHO scratch areas can sit outside it.
> The crash kernel then faults during kho_memory_init() when it
> tries phys_to_virt() on the KHO FDT address:
> 
> [...]

Applied to fixes branch of liveupdate/linux.git tree, thanks!

[1/1] kho: skip KHO for crash kernel
      commit: a6715d7ec472a476db17787697a4abda62962284

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: fixes

--
Sincerely yours,
Mike.


