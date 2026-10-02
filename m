Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736CCCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766D56B008A; Fri,  2 Oct 2026 14:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7183A6B008C; Fri,  2 Oct 2026 14:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E766B0092; Fri,  2 Oct 2026 14:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 451DD6B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:29:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2D67C0857
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:28:56 +0000 (UTC)
X-FDA: 85278522672.06.5C1092C
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC583180006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:28:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=knTdyJnx;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790965734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yop7qOc5hOSleMKDtWQuK9wi6ARl8ykYetb7shbGu2Q=;
	b=iItHC5KKd3hcMSc/ignB7jNghK3PZFWgM/bzGMvcagQvAlVovJKsPhSEhd0NfoWnNp12L9
	ss2pjWHuF99o2lRnwwa5vShgDPHi3R5ijNp+8bUMsnfv8hd9KZZicT46MmNZfeeg0PNJZs
	MakcOGJphK1dB2NffKjYYacTF8EkorM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790965734;
	b=X+kQCuiq74xmmLflBGaPqbZ3b0r1pOspMOcOfOZAfy9Wbf/zNlQZ0r6Xts0r5xO1kRzw0o
	EGTw1L6gc+y/9GVCfNuFt2OCO8QJpB6hRLsFVQQusSwqRy6Oh3TSiwHxCik1v3MFyU17vZ
	RJ0rKvEylLl565heWB8+0P5pXcXu2TY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=knTdyJnx;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1682bff3cso355755e9.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 11:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790965733; x=1791570533; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yop7qOc5hOSleMKDtWQuK9wi6ARl8ykYetb7shbGu2Q=;
        b=knTdyJnxp5i8C/D7ItRmVFjbpgxYEep55Q04ArOvOEhShuAiCtXGpFqqwA4ATPbCLd
         cjcsc/iwC/x0ZXNOMqYywUr68fvjvXBXyQl/GzpR7wQG08O0dq0C/5Y1Z3+S4HF9F3pS
         S7ZIPXguNBCDqYdhR2SLrxQ9dAsB5uMXZbtquB9QGUntDjSbocj8k7hWf4Xj9P5J6oe/
         IPDcpR7FWf4dt7ehGuTU6oNTbqwEuLvdg9Eb7Tmy9ZmaLdeGLYWrlZCs0+tI4hq0HBDW
         Oqh4uvr50fTNxYoUuWQKCVcMYES+sOnWMRpczjDUZ1Low64Yx0k1eDX7w4Dml1oL+wYl
         ankA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790965733; x=1791570533;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yop7qOc5hOSleMKDtWQuK9wi6ARl8ykYetb7shbGu2Q=;
        b=Vjj7zrxBpKTJndyhMohpiGTtdEhjutZUiQgaZ5j6xIh32dvJABbsaT3M0E2nyP7Wea
         cWNu6yGm/Gsp4Y4xVm7KIWKJeazGgPakqHq9/QE2Wl3TwU+VZ+kCUdAhRCT/Uj7nM5fd
         mqFvASv+gMvZVkNEQsb0McS8XaSz7D8l9Iiw5xPEa3mmnR717KuHcZtYaD6Kao58Y+Pz
         1VNDvZbtnXwH0uWxj7lpFGREbxgBERfCDRa18LyPtjP+uLLzoodEG6zbo0+e6TEqe0DJ
         KahHEsp3rueBnWs/Rvb9diEM3lPSDW0A8/fdShsN6PZIwy34624JURoYja2yrcg2klmu
         797A==
X-Forwarded-Encrypted: i=1; AKwUvBy7txpYgS3T3cGnVWOl6IWgADdyT13dnVerWOyxj6b3O1wFZI+YWA+eVuqV84uRQ0eNw5AmAPGwLw==@kvack.org
X-Gm-Message-State: AFuF++nsCv97WtNVD4LtPQJdn+Wiy16LtY/5b59eQDGK4oLuagWXegid
	ri6Ju5NjxBssHj2t9NMzBt/ga4OmGNAmTmFAx4zXKSUq1GlmlkZC0K+pnSP9Kg2Zj9r15ZEFpY2
	JaSpj
X-Gm-Gg: AYBFou3KGVrPNFjg/BD0k9kuvB5s54xzGHLKhp9Zs5B5HGwvNPZ30oMLJrPSvVcZOty
	Ucdsy3fb7oymCbMUF9OIWcAPHUfxHRDnLsomrPzyFWrMuQYhvxh6a7doR/9kmBPo+SmKuomGrwv
	r9QN+YKnMMWSCGWmn9E61p4mxviwjO6yynbRllgDa2tC8YWx6du0ncIyB5ncPLObOeT0QIpd3AS
	8cfFAVlOubvF4spQd3WlDYN+U7ZMDek+x7qXMKN2ONiLb3FpjE1nhNDL6AFel7yFZ6Ymt2Uogyx
	z+rmJJZbOy6XdyW8L6T2FEBlpdRnhAlkqJyY/ZmtWO1XcYPVzHr4bG71qmf43syWriTMTQRwy0v
	gOHIXffmmtNyil4FWmn44N3TS1IFvv5uvWuuAuQ/1Pjj+HBux5I6qaV+c3QeGKrr87aPJDcNThm
	31ipHiTwZjjYVODsGJdjOM2BW+5m0264F1jLU11hRiIZXoSSvhaJZM8ke63Vx4hGYpzR4=
X-Received: by 2002:a05:600c:3c98:b0:4a0:37d:9e21 with SMTP id 5b1f17b1804b1-4a168101d2dmr5201745e9.29.1790965733358;
        Fri, 02 Oct 2026 11:28:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::7:9b19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380f0858sm8166687f8f.8.2026.10.02.11.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 11:28:52 -0700 (PDT)
Date: Fri, 2 Oct 2026 14:28:51 -0400
From: Gregory Price <gourry@gourry.net>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/damon: use damon_get_monitor_folio() for hugetlb
 entries
Message-ID: <ar_3r2fNKNRjmzjP@gourry-fedora-PF4VCD3F>
References: <20261002140727.701709-1-gourry@gourry.net>
 <20261002181136.46472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002181136.46472-1-sj@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DC583180006
X-Stat-Signature: 8x6ktfsmyw1hyhfjmo468fh61wfyuemh
X-Rspam-User: 
X-HE-Tag: 1790965734-117283
X-HE-Meta: U2FsdGVkX1//prx+9j02xSJPOgwXdZi3k4Pzx6IT0wYAcO5qMRxe7TuM2OQ0q8FSxuNOf7QYrYr6hTWZY+4siP6N+5BjRwPvPJqtuZ+cMxVs+2ZMRZ7GaiMohw24VgpiK+x5WTgDqHfaBBLYpnVVsdXmbKAKWyDEVwlo6DqW3dfkIUwuJo/kBE1NqzGu9WceuyVEU15bo/YTO7LK1F7jw8YXfbHKs/b6pej8Pz7O+DbX8eP4lqc7AYTDN9KXNkkoacaQqHsHvajWcdjA0+T3il9T0zusUBbZdY8vaUpPlaLsoJCgf8dmn8WPy+ZiIF94vHHO+eQN/2Or0zsmMjV6AluymN/eZRwbJ7zqosh0uql181FWKaxRNjwA24L8PbMiv/Im8YYUx9c07nLwErDOkxebntttvaiWt4amhW5b5Wjj6XCfEEeYL5FTmaoC8Ry49hVtnjO3Dljn5JXiuhE6mJ1CSRyI3viFCGJkZvQQT2G7nLYMyJLLKQYoXFU1/gXmJPW89wheVzI1DgsSB9tWLXCSUEcCEgGZ9ZR0y9lsTUx/WSHTue8QARvviElH6xZ0R0D2hdFZ3dEMWtWzL6FJb8BFGriUJNE/AlmbgHnvMYTDPS7hWWjkMV7f0u7d6koes9qORwHsadFugdfGezLWp61bigKCGMmaTeG11j9wXyuJPeO5Y+9OnNmnlj//vBsL8FqDK/wCCP38GdO8QlQM7qvwI/2ocMuc+ihkE6/u4cu7Fz3JWbUmSNX/a5TBu9jw+tFM9vFKUo8OyYRE7Kzz/fJtmMl9Ysnmu21HxO8pwhrYs+jx2I5QwCrhbX4i33kpCZ3Zf/GjF4pUF87YWh5oe9QlYqaGH7U1702EFkzCbAD8ydDKnsmp2QPUuRJFN/8DZlduqDQi/ceByzVLHYAWOYBc0A7v4FgGOveOwsHQuZkYYyMmIeEmgjw6WPOhqQcvMpA3Lk/GpPPKEAOfziO
 iIO7J8El
 Ib9ilHX2r8auTloqYqt8PYehJK8+AYyFSSyXwL5imQ1NA2sP8vITsh6gHDrDujy5/uL2CyCVu6WM2DMaMcMVCPjjxaJ5gvoqfvMm4xw83wdOcNkYMugbMUdekZ6pe8oHX2YQEmVf+bRRJ3pXr7KSIi7Jen+kVneuoTXxkf8DtwJ8l7EC9P74GnLVV0ZIvX9CMnALyTnw7vdbxwSwG4a2Vpr94XE7Rdp+ZpkGjf64pMOWOneVQEMpW+syDVfewvhJ8D5Hk41XpELJMrkVHirIu9d7XnHYrjyP48G9hmQyVoL3KBz5/WulZIRb71BgcIvqyl5jUKRr3oq6F16Urh4Wmk0nqMeLJ7NXEqWbNZJGYJ597HAfye9b3zTcePTuvTJOMmlQLV0laYm6AitbaPacIpGpqo+RW7qrt8grm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 11:11:35AM -0700, SJ Park wrote:
> Hello Gregory,
> 
> This patch is applied to damon/next [1] tree.  If this patch is not added to
> mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
> to pick this.  So, no action from your side is needed for now.  If it seems I
> also forgot doing that or you cannot wait for my action, please feel free to
> ping me or Andrew.
>

All good, thank you SJ!

~Gregory


