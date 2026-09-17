Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17FC5C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27F46B0092; Thu, 17 Sep 2026 19:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD43B6B0095; Thu, 17 Sep 2026 19:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11C76B0096; Thu, 17 Sep 2026 19:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98DD46B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:49:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83A78801B9
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:49:46 +0000 (UTC)
X-FDA: 85224899172.26.B09C2B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EA92A140007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:49:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TfsMhic9;
	spf=pass (imf23.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789688985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+s0LiPHCI9anNwog1q1wCmxZuy74xNwMr5QmaPk9ZM=;
	b=VhSOEJYduyh7j/zA28mVQiXqX+Abx3RMzUnADhFMz4V3OUtScS5qdB1HJ5eRl6u9VX56s9
	YIJ0Wpeg5B0BxOhn/J8pfF2YGClIQBNWgvAPdg/ERYQB6bnXpZRO3b0hZNl9wM1K0TVyDR
	tEa1ztKtXChR1P3UWJXZbB8Z7Sj5JGM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789688985;
	b=Mxb2pL5cvxLaYrAoRAvI3wkKYAm9xMA+f3CrcxaYXbswAHFwsFCXbLe7T4gktee2TH3agN
	w/ELYS3WZD4TyX6/A9hToA3qMETfVVuzIild37se1YuFOt7lEFN2NZqcr2+j0XCB2HjjoD
	Yjw/SB7bbu58/BMuO7RHTMdnUEw2xkE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TfsMhic9;
	spf=pass (imf23.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 251CE4184E;
	Thu, 17 Sep 2026 23:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0781F000FF;
	Thu, 17 Sep 2026 23:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789688984;
	bh=r+s0LiPHCI9anNwog1q1wCmxZuy74xNwMr5QmaPk9ZM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TfsMhic9doUbsB42YOZng4qb/OEY8ycWIK+/HxMLPdrnnK/XcZvCH8XBTVwHMHnwD
	 b1K/ES113ArKc6RJFl/7qc0khZYsrIW/DmKux9tzrAGYnH2UzxT4CiKelFtWLhb6gR
	 1ZGKtQjyoyghPjecZA3S7ZuQshkjtU3PAFTGoIJodlHw1xFt+aHcMZ7OsOC0SZgWcH
	 G4IhDihfBsiMYy+28qqVoFDCM/TzrbRrQVKwqCJYowbQTsdzlIyGXEBkLKFgl1o3Qa
	 +KPbQTAeaIqGx/8LkctLSd9Vh4P62c3EC3IE+sFOOiaK0ab73ANUAn7G66MF+Y7eQq
	 EHQDF4f4UsXBA==
Content-Type: multipart/mixed; boundary="===============0095006719181285834=="
MIME-Version: 1.0
Message-Id: <fc85d83ac07c116cd243a2bbfff0a994abcea9e9588048e80f9a1234d772b757@mail.kernel.org>
In-Reply-To: <20260916195203.1099646-4-ihor.solodrai@linux.dev>
References: <20260916195203.1099646-4-ihor.solodrai@linux.dev>
Subject: Re: [PATCH v3 3/5] x86/cpu: Inline generic_identify() into identify_cpu()
From: bot+bpf-ci@kernel.org
To: ihor.solodrai@linux.dev,bp@alien8.de,dave.hansen@linux.intel.com,mingo@redhat.com,tglx@kernel.org
Cc: ast@kernel.org,andrii@kernel.org,ryabinin.a.a@gmail.com,akpm@linux-foundation.org,hpa@zytor.com,andreyknvl@gmail.com,linux-kernel@vger.kernel.org,x86@kernel.org,bpf@vger.kernel.org,kasan-dev@googlegroups.com,linux-mm@kvack.org,kernel-team@meta.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 17 Sep 2026 23:49:43 +0000 (UTC)
X-Stat-Signature: by3a4qnbar7jr59myj6ewd88wxbkhez1
X-Rspam-User: 
X-Rspamd-Queue-Id: EA92A140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789688984-72109
X-HE-Meta: U2FsdGVkX19mjG1G9Cb7SJuUjU3kRubDCpcpF/+gabcLjphmkJd1DvXkgF9VQnHd2zJ0TIqooPx2oIYm5LsmcIWgDeisDYOF6v/ar+iV8eo3v1V6swtgMcz1P/+8x3VRujSOZEk0ZBxgOe+a/JeEMfk6oNTUuPfAbA9uT0ZsoKEokxZLw7Rea90LHViKNRIGRYYS4Pe+W/LfCmGmQK9PFaBWH+bmMUbtNw2a9zNoIcjlB2+OLyP3Sg2Pm479v6qVeZy72531xxmypMm1fMy6nxAThtkufTxuwZbw0Pl9jN4axgwOOaZrZJYpB19aXUp6ZQDDJzBO3ZoF4xBmZbtELUbi6jMurXAmvF6vEjlv3hb+5cSc+TDk4qPNeCDBcb/0w5YzKcxLJAUU95uWX3jNqryvbIoOLx6JzJ4Bk80bB9lWpdY28/fR+XYiUp0jQP5BKc+PEfgm6Ochw1+c7H3AXG7zBNEmjqe/nZlpwcdqYtUYEB0v8SRDDS+D1RdCY9V3166qtEuo24yZCo6zmhp1zNzO3EYRaMw3h/h4Zdtpxz/Yi6CEWw4FdcLWO+79jcj1/vpMhizoCa9NYjIFnytnJ8C3/uW9LB4pVgLLmw6vH292ZCHJCAS96WBpmyWMRALGJ9K4I5CTrLwx2dg5s8xSc0YVxj+HXBcLaen6lZE5cF+o+ookJac9k2l+qsHBGLhvuHjo80EFIPDWY9ZaPAUhrOgmDbhO1cniiEU0WJdxjd/3uWRHPT6mdJAC/eGsHjQhIoXSnEZEFliPkWSsZ9FVd3mMFPGX4lGJsMhGCEV2mCKVCNncnvxjN/M3QUJd/AWx2BQus4aJfnW4y0TB5kXiB6uj4cSlQW+crr7ps4WB75CrhoCrEvkCmCqpzT7MDHicBZ5zPt+Zqu7YWLVVcPlmEckQj2lkNXLZItyR5llXcbyrf7CUZcanlr7EwmjEtSkmp/vCwS/P8T+ka/0KDER
 LsO5SLI/
 vSvNOSJjwV9yhNNauZX7PbacTCWRLsUXm7lSD3q/x8Zjit4rKRKRnLsyleasaKlWC0id8iDayl5Cy+8Fra2GUZmEgwc47icGBORu2RFwFVHB5S8LrR8FSIoISS8UATuNOhqovjKDX9P9GtHAEN5duYuovPz2yKuH9/La9c2ZI/4i7xdnVBOTAEB7gnY/4jBczR+JtyBtcjhFlvNbcWVukIPSynfU/yJtqtNp3mf7K/wvylCTMng66YCnZzx3UoTJ4etLdEdY7AVtx0ab5KMq8Mx2az1I45Zx3O6wTcEJBzWPyoEnE1EUS9TSPTX9Lf558k6haHpNx/M53YnUGIpDOvNqZBbY1LrUONnC+YmxzgrO6r6OeMMG3/BdpXWua56YtiIvGslhNfZE2YE/mO93i6Rm0qR9awGxPFtOn3yfSNxtAksI04zrDoHbaIrZFT/Pc9j8fQY9/M+VGOhHyaMXQbA1oouipzPs11Bf/jx7Ug82Ypv/Rgl9C0fVYntKLl1gZGCbWaEnpJ5kaCHjaEVIP4+qlN3D35NgmlG7T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0095006719181285834==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> generic_identify() has exactly one call site: at the top of
> identify_cpu(). Fold it into identify_cpu() so that a single function
> does the job for both the boot CPU and the secondary CPUs.
>
> While at it, fix up both copies of the Cyrix comment.
>
> No functional changes.

This isn't a bug, but since identify_cpu() already covered both the
boot and secondary CPUs before this patch, could the changelog instead
say what the fold enables for the following patches (e.g. making the
init_cpu_info() placement explicit)?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35285131592
--===============0095006719181285834==--

