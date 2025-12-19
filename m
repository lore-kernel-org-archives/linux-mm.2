Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB55D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E7C6B0088; Fri, 19 Dec 2025 14:23:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2026B0089; Fri, 19 Dec 2025 14:23:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA4D6B008C; Fri, 19 Dec 2025 14:23:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F12D16B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:23:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F49313A89F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:23:52 +0000 (UTC)
X-FDA: 84237195504.23.44677D9
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id A3A1980008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:23:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sDiQVDby;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766172230; a=rsa-sha256;
	cv=none;
	b=iJ5YU6g4e0X2vyGW6KAYu8JNpFXUd6BglKkkz9IH1KeWaRnA9XgDrrdNIEdvVJd4qNdsA2
	v7gwC52+KY10zVXRc85EG+O2V6vvX1jBAuhC5IZhD1EI7iRIQQjp+Mh4UCBDdBDxDkHt4F
	oeiyHvGvyLg7S+UWOaYsQlNNTpvbfeQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sDiQVDby;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766172230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtQWxqRVaXYCtRr1c6g3cGsf+rz0DQhO4fXgYgtw3nE=;
	b=rrMsX7eiexKPIjVmMbGzFKDgNTxMmd2mGQMtSXriainHX5noCd4jJPKWxB+sjvfEo3L94i
	K2IuwUUHrLay9iH+KPwmzW16CDz6tp+M8tMhUlPjJZIx1sb/oLXITUfDPghtkxj+0DESUk
	GNrXrX6cEeIVYJDdMxMww+0hM/8TULA=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b2d56eaaceso249111785a.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766172230; x=1766777030; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BtQWxqRVaXYCtRr1c6g3cGsf+rz0DQhO4fXgYgtw3nE=;
        b=sDiQVDbyw+uPfmTCaltzyISssWCDAGaTAIiH39VMrnec0hcu3o9jmdhduJqZJTmtKw
         452GGJtJcX1Ckkw8jclGFYBPqAtsEQefPuTNkQ8AB8tAHHd9aD/Ep98EHgzBeM9QV/ou
         e6tAIzOLn0EWD4bXs00Bb/dA65NG3SGBIhNK2VYLjFyvIj2P/q8SM4ZaW0Gu+CdesqVI
         mZgOJFVB93PCakUSrhI80uK2PLKfSVqeEE84KEYU3q0vl+wGeow/yiJrMUYKbSAQTlh9
         AEMzpTieoiJjJra/sn3HHZPfULr/zHSsp7QY1lMXfF3DD6gyK9JeTMYgZzH5PQLw+CSm
         5hkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766172230; x=1766777030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BtQWxqRVaXYCtRr1c6g3cGsf+rz0DQhO4fXgYgtw3nE=;
        b=Rof9zVxsBJwdY3c0qy5nG40bGge2aEvgmVrLpym3Ksx9xar1ypEe3qQZDSGYkWzGOP
         kYHlEKPENBYBD0XGZN+3ZiVX1sg/MnlL4mYoi4FkuPrF9wccPmdJ9f4+1eYdyP1my0f7
         UH6tZVpYYT0E27w884zNe/jxaz9HFGZBkfrCa/cZy7nfQUiH0FBT0CjGLK58HcIUKjOV
         tZ6WbgIyknvS/iT7Et/kdYwRLtm/SEKgNzaVOsW/Wdp2GLHERJJ5vG+1icTFk+uf54IZ
         Cvn9H5OPOdjEU4fAqr716Xq0hKcW9qX1xHPSO7eRGp6iesxPmg5Ze3MaIRJEqMGD9gE2
         F/kA==
X-Forwarded-Encrypted: i=1; AJvYcCXrSXShm+zqi6zs5Yx6ltD5rQI+eI+PIa8YRPToXyZdnf9lm4iZKYqsEqV4PZuB7Z6T+r1cJ+5tbw==@kvack.org
X-Gm-Message-State: AOJu0YyF0ozegWuZa58ORWciaZ3h4kPRltC9/zPG4IgDDK0iWyXGVgUT
	T1LCAw2zN1NXo3yWzZopQcDFSaAC5eKm2Hxn041EfDcuV4P2BtzEx4zPI6LMQ6tJDrI=
X-Gm-Gg: AY/fxX7TWHp+rcCznW0USdcYcGLYs5pnCLIEGs5Cz2FVBfByykBwETFhUblQketDNqi
	HQqCmofAFG+ZjGj+PNlGptmZihTOpxyBHGpk00i+YPTiwce63Ktv/viWBvP8+DAZ7WQEGo7QqVX
	fqyIuBmjd6YHqPCKbxozUx4UeKME6HBow7fheR3zc2BNglFmLTvcqQGQNSvpHzBMV/Wmu5W+1Zp
	xu4rrPPIJPraWlKO1CnVuxj5TQ3pQDtQj0Gev29SIDPCAqmI3Bg/zOnwnewKK93zfUlyqS6H8u6
	iwy3n0LA6wu6Uyx2bjVVqv7+2Fq9k2yu0qoeFanpbeqGqkYMVLPVGz9yZ+FZx5V9fAOKr3+o8qk
	LM6l2avHoKhoYjucXI98yOUco5emiGY3ARvdkVfUdl3J3boCGYDTxMLIpDQzJIJAXO0C4+h9+TJ
	FAM/TFxThFcV7BU7OxL2QLSLKmtzc+tlEGnw6FhWFpNlI0z44m3BApOf0gVqgC2dmyTVF/lw==
X-Google-Smtp-Source: AGHT+IF3FpQuaQstYgOZXbosC3GlOsWbzEhcXnwifTmhBta+D08VLCovSdHO/wkeFcR7FK5Ki598mg==
X-Received: by 2002:a05:620a:4054:b0:89e:67a9:fced with SMTP id af79cd13be357-8c08fabf2damr601467985a.66.1766172229635;
        Fri, 19 Dec 2025 11:23:49 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0970f5fcdsm240554285a.29.2025.12.19.11.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:23:49 -0800 (PST)
Date: Fri, 19 Dec 2025 14:23:12 -0500
From: Gregory Price <gourry@gourry.net>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	mgorman@suse.de, linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
Message-ID: <aUWmIHeobTR3Qyq1@gourry-fedora-PF4VCD3F>
References: <20251213082911.1509735-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251213082911.1509735-1-tujinjiang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3A1980008
X-Stat-Signature: swn4f8qiynpg7r3koqyr3trhk13xeyy1
X-HE-Tag: 1766172230-967607
X-HE-Meta: U2FsdGVkX19okwqtJ5SEchcNLsae+uZoSv2ibUy+t/Cs1BGzCl7E//rDPe9ArVHKg970BuCKLg8m4ABGaO3PJKSt3LvdozOfMshqPsZeiMZpNXYq7Pf6lH0nG2hEtQCo/gqjBnEV97eD3Iv54ieOQoByv1v0lKgNT1zicoxdV5ePWA9QD2WjhhWCc8gLq0yO2XuwAgG8+uFCD3Devx60Lj4n+lWbVqPLd2WA17Z/VqJoiv/FEyrublNRuEs5qo/iLdiaHj5xT0JEYtFmXZsZTTcvGi/cXRbNEj0Kk4vrVxJBN7QJ+75E/3Qup5b+O1anZZsWEym8mY365EqRreHwrIWY1hRrHOzrZlSKPF5khZg3MaOYY4XJ0cR0Y7Drcmdy6N9QnOtYFkG1dj5ZMe9XDugTxtPck8D2zZf0xsyAKtZDom8IF1SstN4ovbeO/6dd2Hax4IcdKidlQ7Aefdmp9lFi3Msj41UYAk13pzk61M8nIIcDB0SxWSiRza0Y59F0S32UQ7hjpENDTyNccxTEdjoAbZM8QCOM6r7cVC2Wi5DF8qz1MJ3hLK6ntyKYDNqWTf831WkA/Q8SAzBhyahYaip02sMVsDsx1fXeDn8XeJMzQFFwypxiRxS5TXWC+EEhdPMltCL/7ShxivwttsB0DJCUrFgbDwDe6W2nYaxqcupODwW2kkGyTz7tVW6hT+d3ngUBu0C0FfmWoTuI31wsAmscHgUEj7TtM9ufISA2wOi0joipH2/PvyjRVGv78TNxAnShX94iY2aDFCFW6BkNkaGxrprc4hFPKhFLVqfrnnnopCKYOjYjhzjywwtQZNHLJNUwIVhNYvLT+ipHmqlmhEIYqREX54neyGDNLn+J2A1eoFs8ZRzcFSPIV+K8H7g3k/sfBhrwcMQfHA2dtCFbldmXh01RkPkevmQciCMJXhc4VCEm1EJChaM3C6HRzonpiBfSj5Tsk9YokjKi4I/
 CzpH0jw1
 hZ9pK7b4QetKchRXMy1iUkPPqaiAjARMJVVm+4OjV5b/4tRNqdHK97yyJ6RkePbemgwTeqoortvjVFqp08zzIfCnx9wJDvqZO6Ebgp/mvlPkz6Eu/W2Sah8DtJd6S1+krTacrXSQhVSKYERGAZmf/FPT/DXnb5pSmfXk4oilOHqffVg1wnwHlVtiUw3FRLKp45w+caOAhSGet8GCxGclx+DTwmnqEWgYYqgpZCtKhMu+jenIvawFRWhPwqyy7JI5420feYqyycJfI4Tc6P//BvvK9V3H/2cxuuxAUZGx4WWOz323EzbezkU88nTIGmQIQ113n0SEyy3vILccyOaWEbMEQvP9IAwDgq8kkkwLm1PMtCQYDVNxWISfV3SlqX5dBkPdIcJ62vV5LvfbqP3fjExQruw5vgw8GzV8ieFEOkCxkK7BXGQV79TyVhpcLAoGN7Nfnx3YmUG0zelHny8W807aSCmiyHagn7C26HUramv6pDV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 13, 2025 at 04:29:11PM +0800, Jinjiang Tu wrote:
> When mempolicy is rebound due to the process moves to a different cpuset
> context, or the set of nodes allowed by current cpuset context changes,
> mpol_rebind_nodemask() remaps the nodemask according to the old and new
> cpuset_mems_allowed by default. So, use mempolicy.w.cpuset_mems_allowed
> to store the old nodemask allowed by cpuset.
> 
> MPOL_F_STATIC_NODES suppresses the node remap and intersects the user's
> passed nodemask and nodes allowed by new cpuset context.
> For MPOL_F_RELATIVE_NODES, the user's passed nodemask means node IDs that
> are relative to the set of node IDs allowed by the process's current
> cpuset. So, use mempolicy.w.user_nodemask to store the user's passed
> nodemask.
> 
> commit bda420b98505 ("numa balancing: migrate on fault among multiple
> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
> for MPOL_BIND, the behaviour of rebinding should be same with default
> befaviour. However, mpol_store_user_nodemask() returns true for
> MPOL_F_NUMA_BALANCING, leading to mempolicy.w.cpuset_mems_allowed stores
> the user's passed nodemask instead of cpuset_current_mems_allowed, and
> mpol_rebind_nodemask() remaps wrongly.
> 
> Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Fix looks good. Thank you!

With changelog updates discussed in the thread with Andrew:

Reviewed-by: Gregory Price <gourry@gourry.net>

~Gregory

