Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C72BFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 00:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051856B0088; Wed, 29 Apr 2026 20:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028E76B008A; Wed, 29 Apr 2026 20:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA83A6B008C; Wed, 29 Apr 2026 20:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD8346B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:58:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B169FC254F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:56:56 +0000 (UTC)
X-FDA: 84713407632.25.92A0D4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 291C714000E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:56:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T5O0uOFk;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777510615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EazxW4e6oGHBwYfUsG1yPydjnWNC/W/b8dI3XNECX8Y=;
	b=kNhqOMlUA+YIy0TbwH6DX3rfI5LBJnGcsX65pYLhuad/g5tBuJwMnBr3P5QuYGDjT2RdbK
	XT3KKBLapqnJ9wIY4thhC9gytT+yUPJYnS+PpwHdobEklERD0kZBaAM3z9SZ+DFL6oZ+Lr
	+2VSmon6w6iYUuxFBS0TnRI4PAhCdoE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T5O0uOFk;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777510615; a=rsa-sha256;
	cv=none;
	b=KoyYpAExyNY14Y/aMy1vGKQEp9uiT4vGFUBaE/nxM6Amz+V0JnNmfRK1Am3cbncvS+5RdS
	Xb9WrbQY7GZM6+5pZRBp0c9dQBJ3Hzp8aHwZUwFP0Za/ZIR+ZC7Gk0CRERkYP+esnh+PiU
	ST0l85X01HjLTIY+tOX3QWULQ/RpTbs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 247116024D;
	Thu, 30 Apr 2026 00:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A82FC19425;
	Thu, 30 Apr 2026 00:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777510613;
	bh=iKtlWudWf4yk0Lw+o/8AER/401ttw3Z21zzRCj0TtyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5O0uOFkB400nD6lpKCMSJhkVo3JAz+oQGI4I1AYyFmKnID7GhY3MajEdF+gonuiy
	 kPw3kFuwGCWFPghkeNq74M1zRcFk70/Wo4/o9hspxulsq2lf7V/eTaRMy614D2ciUT
	 IAteBdqdhamoTivv77BZCpUNVGVefsA3TcbX1UWAub8ExTz1cVkRlHIOyF3JyCtffL
	 ZZKWYQGCVQcMiekKxKI6t7btxPXWVTxNPREnHs9RlP9iEvuvw4ro4J5bLri11gswva
	 KopiZLOt598FQCTMPWZoYxukgy/SOJSb0nBoyZxHrk5qFfqRHf3Ihbah1Po8vp5z7O
	 vxnlv/dNKN6Cg==
From: SeongJae Park <sj@kernel.org>
To: Manuel Ebner <manuelebner@mailbox.org>
Cc: SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	rcu@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	"Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v4 2/3] Documentation: RCU: adopt new coding style of type-aware kmalloc-family
Date: Wed, 29 Apr 2026 17:56:45 -0700
Message-ID: <20260430005645.113819-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429072320.310817-2-manuelebner@mailbox.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 291C714000E
X-Rspam-User: 
X-Stat-Signature: ro8tccy6gej45xrmyi1aaucrr99erki9
X-HE-Tag: 1777510614-529893
X-HE-Meta: U2FsdGVkX19mGA8w9kTJCuH7KCTOxHnRtgOV+4WH2hpS/PFaSrUNgUyQT2oPWC4hY/4OmoX9RbAHUrTy1XYdHTuOJH9tDdfZWqoyUE2fsUM/MTJa/nvx1qN7AT92W/Cr+PXIcMFXoD7BAFlOL4m2XFnX8IAcLYZtVGtcWS4+MAx+tibY6QRFDEgVsoXbnwYFUH6F0+j+3iv/iAyA4Lp4Ctt3QTBNT2WneBKBZh4Xji/zE8EtAUjP4IrEVrWKgFYtCawIjiJPmj28VLo3HJ/Z8WaBTxxa5Pk2YpPAKAw8uNv1m0+CrrWeitg+TDFMGh3cOTpJl47j5KdBoSLcW+S4hbZ1wthyoy0CXApsXTRFMd8tFCYEp6uEI5xfeajmya1OoynSuBnXD7VSqewG81/OUMGpr5dexwWUMigrfJ2+LCCrOOvwSIuaGIlfm6D5WSNWub/WexUx+lUeR29QOcmpXp0Mc9QLIWTIuUoaNSI/l+qOfQ+ucXd5xXvO9t1ikzypxy/rB1R+dAvLVNzqrPjSyU2h2EyOZdFtsQstlyWL/8SUPt19dY2mluiZGzrh39Jdgew02cn6838w8SznSlFHV/7FuL+iKAD97gquebQ/O5ytQ+KtA0Di2O5Em0Zc/bcXLYfWjrc4/Ilp9775jyDCvpsSC4Je6tzpGkZVVS52kO8WuD98/cm/13NvzknUsvPtXzvoq11bkXnPjNKbyJs/vyPWJpRoM2u6j+Jn/csf1Uo6IGhPaS9lwdEU5rviql5LwoqHAXjigyO1fc72VqqJaWEZGhKjXV1moRq/CprW6/SsKXHuhNwvler24Q/xWd61soQR6YxdDFOu5tL2koOF6tLd9eso/nRVpdTcKOPhNu1hBnsRb9EpcypOgxe9X7KbLGzVArgR5egryz63nQGybvoGL71McKLzPlXMvzoqQxwoUFfWDtVor41bPh/boOg8JoVVuJAp7rfWJkDByze
 D11x1oYs
 tKPgw/9GYE8oqzg1R50kVb7A/lCSFQvUowKM9ZmP9LqBAFmBtBeOLj/gqNy4SC+9hpHHnAFizR4ExlGdlKCTVYwdSVI1epbzmNYrQkpSCfvIdTQ3Sy0gtcSudGUXGsQSJOsLaer5+md4tqfe2w5JQcttEiWTIMGZYk59RcNtncaNXQRjVYA9zdYZ3Ey8SG79Cz+59A0Twv4kr5qdh7Utou3S26BPY463VPswHM0t3EEBGaI9SykYqvx7trdGLCVVW21CbKR8ifL3pWjVok91HwnrKSOa12GXDgbhI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 09:23:21 +0200 Manuel Ebner <manuelebner@mailbox.org> wrote:

> Update Documentation/RCU/* to reflect new type-aware kmalloc-family
> as suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
> and family")
> 
> ptr = kmalloc(sizeof(*ptr), gfp);
>  -> ptr = kmalloc_obj(*ptr);

Shouldn't 'gfp' parameter be kept?

> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> Acked-by: Paul E. McKenney <paulmck@kernel.org>

Other than the above,

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

