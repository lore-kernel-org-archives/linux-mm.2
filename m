Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D7DEA8118
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C51E6B0088; Tue, 10 Feb 2026 08:45:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F9B6B0089; Tue, 10 Feb 2026 08:45:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C9F6B008A; Tue, 10 Feb 2026 08:45:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5096B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:45:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E8FD1A0562
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:45:32 +0000 (UTC)
X-FDA: 84428669304.16.DE7ED7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E07B18000D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:45:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c+FNjQ/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770731130; a=rsa-sha256;
	cv=none;
	b=K2ayVd+EchSMe8Tz1DqmVnUvAPT7ph2CUJfV2aDobi+FuiRV2+cDRTUKwvck7QVOZMCL7n
	MsncfBgSEyTFuJtVomfPlcbBT/MYD0h81rrvoN0Dd2JQGbBybyZbjj+eNcDgVr06xoeF80
	dIrvcVceR4t9Jip8CpHi5TEQvVukDQ4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c+FNjQ/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770731130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WjuB1ouym1wo/KEjTHENRCgQ/UfyIRZH7SsAgVNj+I=;
	b=EaTzPWVPSJUCE4Eg+CACXscDieblVXkHGt7gzQez6X/ycY63LjHtWVX3H0OXLq19tyQVkh
	g7tLAdcAR/h+tSBhsRaVk0TbgjGVOhPSGHwvNtLxhX3doVHbNH5aDQZ265q5IOXGfKqorI
	pz22jUpAquxprKGuilXWglVPx6Hz/rA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A8D3439E8;
	Tue, 10 Feb 2026 13:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B7AC116C6;
	Tue, 10 Feb 2026 13:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770731129;
	bh=UiB4cdtuv+0naMTeccJX5N93CPAw51/JaqNcoV4zvQ4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=c+FNjQ/k6DxcaBj3u8nCXsgF+qR8qI5/JZNA+al9t07HxZPquukG6/3JTaG/GdUf+
	 0mpSuXjS9hPiec/0YhKAfDeVk/b0Lma8BW5FObxZDhilUcfn+HL4cPRoyIHawxFBYD
	 5JDUXg2sgnOnp9M4SzAHJWx8MwdmjJdssl0G5BCiWm/A2XpX1qlMJq7N8Smg4fpoZV
	 OmNEdZyoweFmJDZKZfAn6lQq+TrSyJtDBmAOj9ES8YXBFoVH4Ed05ei01a4t6pMpN/
	 6fJQO70fK45+mbWpwMjmEH6t6W6sxXY1NNT1yV7Hof71+nk5PISIS6zYVpBb7RP7Mm
	 anRL+9IZrNLVA==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: graf@amazon.com,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  akpm@linux-foundation.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH -next 2/2] kho: remove unnecessary WARN_ON(err) in
 kho_populate()
In-Reply-To: <20260206043121.197564-3-ranxiaokai627@163.com> (ranxiaokai's
	message of "Fri, 6 Feb 2026 04:31:21 +0000")
References: <20260206043121.197564-1-ranxiaokai627@163.com>
	<20260206043121.197564-3-ranxiaokai627@163.com>
Date: Tue, 10 Feb 2026 14:45:26 +0100
Message-ID: <2vxzqzqssoeh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7E07B18000D
X-Stat-Signature: 4qdjmtbhs3mj1gfzd1mjqfia9g8o77c5
X-HE-Tag: 1770731130-318800
X-HE-Meta: U2FsdGVkX1/3zR4Nbr9V1BkKE0gscAYv+LatpbkodRf+A2MO0HxM8DhPYgoNke56qQmDXNyOEZFH1conJc8KphIor/Ek68/A9BzICgwR8OVE3fm36Ur16L/mg1uwa+477zGzJK6gE9tWolg3Lz9Y9IHNiUUdHYd359bRaZMVRHT3Xf4LoGi+DOc+EUFPy0VHyPKKeCg1Ks36mFXLcawX60tOV2yDIX61jtdPdpYSzOGgAfAsvX+tE4jEJOkn1wqLw0snXcxS90U5THOzWoi1qH/Z9li8wbceh0teIQqLg98lPGqQy55NUMhnlvVU8+M//GcmdBYI2Llj8E/RpyndmFkr1BizqES6qObBmh+rQGYHCB+djgZKviM0e4b0RpLxBNCCEbGkivnIDWErFR2k20uFy2jB/m6dOtO1TIo4nG/PPuep/G/6Tt+rCPbmNq71AxTOYuSBOaViXIDs9RkVqAfa1gRkAGlEAph6OTAI00O7xNOc9tBxrXq+vhxDiTpYtdthPIUydhQ1z1WWSTm+HWn0JXKI7sCOAbo37lFH0rlB/brl5DmY7oIXx2gOzn8eXhu1lQpr3MM1JAMmVVoNCY8bS/olG6W9LRl0cUTnUFC10qFOIZKzacbIYyTBeLfanisz9UuBWThb31Vuca5o089rE+9yvKQH5BFic1Ro5zfqt59udqvVXkd/MCE3fVuYpnJB3Z1Za5ubGwA6rjsmjyCsP7sNJq8i+iVWHq7LC9bbl2syeuUaeEGNU09b+kP6veyEn2whaOBX7jXOc1aTLoARk+Ysn1+YRXEXhMVkUXqoPty3xbTDHh2/VT0mvc7eVMzjuw/vDr/QUX2WOK7uQSOxiSEnCLOurSVCipwBfiousXMcbpshnjX5Y322yqoDH2WybxCzvP8ny5OrgX4Mi6/pCxuBMoh8QfizdliNOy7+wEhwAVMjH0G16M/hQ1V+OMqctTY+rNT8+sXWAKO
 raO4qj7e
 5PPuYPuDd6Ogq56qeiPBedu3qv87KquaEA3mOtkHA/9DGY4Pyq9m0TUcmnCAtT2YRGJwbJzrh8leGfT5R3Jt46i7rst0HlsV38fhjjOS6tF6KnFPoGOCmvYQXB68Byl85sdrTTrAlECQ8zsCQwZsF5hX5NUuL/CWSZmmjAj5DYhHXSVQ/ucAXEG1apQb+SiGXvOu6eIuinq/00trfwe1WpCYo8+y7UEmyGjzB72NdRWe9vnbAiaS+vLC4rvLpwN9tm1mqGqTAp51Oj6Nl4Pk4oe+N7hJZ4+4mTf79sDI11vE0IzV5xmBgFYXsrfgBG2CgDwJe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06 2026, ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> The following pr_warn() provides detailed error and location
> information, WARN_ON(err) adds no additional debugging value,
> so remove the redundant WARN_ON() call.
>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

