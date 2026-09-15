Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD7E6C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 05:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08296B0088; Tue, 15 Sep 2026 01:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD116B008C; Tue, 15 Sep 2026 01:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA266B0092; Tue, 15 Sep 2026 01:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A32296B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:45:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC52780312
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:45:16 +0000 (UTC)
X-FDA: 85214908632.06.8AC98E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2E0648000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:45:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecXFsIvV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecXFsIvV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789451115;
	b=6J7D35sQ+dLhK3WGMyppeXv9sHxGsogLx3huj04OKFJEsCd5WvjGK+nCF93AfZGXNv/CAo
	OUeH2qk1spzVmTrEPwZiat4jRN2OEfmIZnw3agaCx2rj67WWGhKelUjmCfYmKwWF4qcXVP
	eCTQDg1vyJsZAH7MguCQkk2SN/62mTU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789451115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkH5OQM9J/Q/GhLi+Du+nLfiLe24ZwtlQQhnR2ApN4A=;
	b=Fzxh9p4KB0strgTRIhlcp2vs+bLu7r9kUO88tzUwvVEIF4HsJxlQTznpYBz4Yv+fRV/u6r
	gdTBJe5wnWlEme6Qqll3mD5ob9/uXHDaTpEeY1f8/C/siCu1UPepZB9NuUX/DBM3EQFS6C
	+z6qsKYCRP9ZlTTA3BYguJzA6EitnTs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E68156025F;
	Tue, 15 Sep 2026 05:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4FE1F000FF;
	Tue, 15 Sep 2026 05:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789451113;
	bh=BkH5OQM9J/Q/GhLi+Du+nLfiLe24ZwtlQQhnR2ApN4A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ecXFsIvVk1QMUhpvZieAX2h7WytAJzaDxJ8bGv0LTBj6wL7iaBRSO4jevBYmidcrH
	 k+jQTvZQcHHAAC8sumGKPyTnJAF7tEBwjkZx9ZN0iLMfXxVPhdZz5IoGgrsSxa1zbl
	 mjtYTGW1+qSP01Hj7DZCNNeiz6BsTwUUmCcxSbK1fGc2U0RcDDusrlMScc7MsJS5DZ
	 7JbjEngauqhEdfj6KoCIoaL+cz1Kv4JmRnS4/P/KdJ1FV3NDxu/aeCxoOD2tSNFVKn
	 rReDMjmZh9VZ2vd0TOgCZ3armPR9dTp1VnfIB98cD39/d1kFE6oDw3AmNFQs0ZRcsc
	 g+WdZP1XC8kxw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-doc@vger.kernel.org, 
 linux-mm@kvack.org, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260905141526.1546478-1-ekffu200098@gmail.com>
References: <20260905141526.1546478-1-ekffu200098@gmail.com>
Subject: Re: [PATCH v2] memblock: reject non-page-aligned reserve_mem
 regions
Message-Id: <178945110677.43585.11156052528524749779.b4-ty@b4>
Date: Tue, 15 Sep 2026 08:45:06 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E0648000B
X-Stat-Signature: m8wst4m1sk9684ymnx9fy1ys1p8tn9ed
X-Rspamd-Server: rspam01
X-HE-Tag: 1789451115-604915
X-HE-Meta: U2FsdGVkX19RPM2ygtlHfnEiKjj+krUaWg9XaghnLcJ0C0Cvf/MPBONlBGY3Ghzg1irpzzz15630MVaI8U1zDrOQKHuIecQMOF6xkG9u+Dj4nYhz3ECwbixDLGicIlnPUMlh4aojJPxvjUXQ+As8pNbWNL8A+VXF182hcTri4hPsjAYRWv2WVqChpYz/jtR6pBcUuQ3rPF06+Li0OPOyF87j3xmpLYKQ9/9hGH9HAL8edee4CYrA9oE+XZeYY4+vfi/xjXCOsAaEfeMsdHvnCqarcmcvC74mEi4vCuMKCnsxmB2twpLxgBj4jtgFk0ooE+pqIrXWN8x17VJFxh1Tm8kaOc5tXWP3k5XvpxgPU3qWrlk/kmsmByck/HuXAJs0notJgVpgXwTQCvqAc2OsnzequHyS5TxVoqnRgk/3IlaHbz5avbciEH/OjVuDim2NtM8WBsEl58BhRbTQZfh/VUe559TO6gVyq8vOw5geP54iwZvYOEVgmCB55HHIh6hZEQriYlRF400cHPpOwfevhZ9afteikr5/mv/NlKp2NMbt0f0Uad7iPVxLYgkJBWr4RsOe0LHlnL1OxjiVCslii+TNj0euf+kQtUTqux2BrodB9rI05bdHoM3ZIE9jZOOmqJ4kP1+QMQw4mze/eYbJwZGjp6USp7baE22PPiCUVs7tIavTnzJqykNAxZzJDow6jkQaCwMBcpNISfl8hC1ymHwEUO22Uqxe7xW2DtgFOrMplTPc6i96B7nIPuwb2sl3K36LgmL+mYo9AFNqf3hQEmFMPl3m7BeXiFTkamirpgeE/Sc3aOwhnafGPyAVL1speAC+96WPv2EkKm7Z5CKYGpzoPv++3A4/min0UpJ3dpORrr3WKhkqWnjhQ9ZbRHIZhpxC7quB1Fmq7XAjA7P/0d6xrOKAh1i+isroEULVp5VLIf+sLBCg3r9WwtJzQuLdm9rZC93zA4xOo+g+jyN
 NISPv+ue
 3UFb8B/3eqk74v4aEquptt/IHPGmi2mp4DkooF9E89syBqhGUm4wGFtX6yw6Mvpad64QXUoNV2nI4+IeVbwzVtSh2ru+I62PgMyEbEPAPri+qr65q8u7YuhuqD3I28X/U/iVwPW38E9v/07rZ4wvl7ybw+NQsx0aAu7/s6T5gTk0p0MXnMS4T+D1h4lSFVciEPTZvjiMaf9Q9wYrjvv2+tzy0mFC9URfhhPb7AFbvPXfr713bLy8FNYBEdSMYlz1HKXlrrXe5gROsVH0STRUOxWg4wYh47fCPZpQ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 05 Sep 2026 23:15:24 +0900, Sang-Heon Jeon wrote:
> memblock: reject non-page-aligned reserve_mem regions

Applied to for-next branch of memblock.git tree, thanks!

[1/1] memblock: reject non-page-aligned reserve_mem regions
      commit: 5728d3523f12826a2b180c1c5738f74e33197e14

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.



