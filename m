Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A990C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01AB96B0088; Mon, 29 Jun 2026 03:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DC16B008A; Mon, 29 Jun 2026 03:02:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB896B0092; Mon, 29 Jun 2026 03:02:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B30E56B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:02:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3274B1A03E9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:02:10 +0000 (UTC)
X-FDA: 84932056020.30.3714602
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 28448120002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:02:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TszeRu7g;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782716528;
	b=YpADYG62nJ/yIMEifhF9t1j6JF82eWR2wD0hG8D2MCRphxvxuoWprdqEcPk1jTAWBa0C+5
	BWAQbb+DQxbZjDP1K0Rbn49UCbYXpC/EcVj2d805/ihevUqEcGRDSQeTt4y9mEGX2aKgXA
	faZx2DytEfUNGmxRoE/zLLwa6oohFS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782716528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkmUS+qbA9gCTt148jOaQOCsbv1HL6/U/eK4SzvD/TY=;
	b=1Gj50uMGdvs7Ouz6jvYgTfXJZmZ3iFSM531+pNGoS72ShSB3vCAY20hOE2h5VGKSVUzk+l
	NM2Pxa2Inh5tL+XvFG1EJmk1ogBQXJr/tPUWpRtdAnmQbJlH8vDSdys2OiOtz5jQBklj7G
	jLai4+f0wGbMtj37nVOh+weaCFE9cCI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TszeRu7g;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51a85b0e2eeso23730851cf.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1782716527; x=1783321327; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkmUS+qbA9gCTt148jOaQOCsbv1HL6/U/eK4SzvD/TY=;
        b=TszeRu7gxVu6RySti6GnfeNI8EijR68HGm2ppTBmBWcaXV1JCnVaCa+NqB7k9xVUgA
         KrHGx7lWImZ99dJuAGpKFafFbV/0m+TxOFw34+9DXeWD3K6tt7y8qGRCFA0Pi8sTCz6s
         J/bi5uU3fzTOTERBrG+ASTa2qS9l2XiD4FS+KlMKk3ERhmcCZxSeqkZd3DlER60Oz7Ry
         rQyDVqvCcneHNgR9KkcUvZ0GM5iZ+8BTfrUixKbg0WsFkWmpj8f9QEn0+Ek7JgYKNin3
         X/6jyZM2mcfoakHgG2eYihjP4xnulGkpIpTu38qPCmvroVuxGkHEJVgeR005+9t1hoL3
         JRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782716527; x=1783321327;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PkmUS+qbA9gCTt148jOaQOCsbv1HL6/U/eK4SzvD/TY=;
        b=mcg3YBMr35Q6l9NARw1UrhN1B2AvsUpKqVozPSLoOAkXGLxi2T5Su2yUzdZBrC+aN7
         NfcXwO+2xx5i6PH5Wl5OKYSxzb4VU4Ftof1q7LyWi6Qv3AqW1CLAJKF/tQBdQOUDVtP7
         70FyXFvQFQ6dBEv7rVybvjJqhTrXWWdu08gffXI0YNryg0+leqJlk5IlYrPyStfIx6k6
         fStL1n5GJUqtdCEGUZB0ntTncRrl3WyRdDXzj7i2ms1rmUdpYUxlz+2g8vJ9lgGzzeoy
         BSAMWx55KEf9XgE/TtHbLNFPGSssoPsOh6CS29Ly1Qtqif07aSkDqvly03k+F6nrzRTf
         /6fg==
X-Forwarded-Encrypted: i=1; AFNElJ/yNEiDxuRxMvWvSJXx7f0n0jnfl8U2sUr8CVTlIZwr49AyO9syzlM5L+v2WLIQ/H9zERu5ls592Q==@kvack.org
X-Gm-Message-State: AOJu0YzTUo0t4lPo9+5MRUGmi7xVOdhNDugBUEJFrFu1QUaYFDvtLpI1
	zDcsg/3gi6JZ6h7MrjzRswL+peB+u1EjQIixY0duaHLZZBt0YBqbJsfHCMOapLXGUpY=
X-Gm-Gg: AfdE7clUGwoltAQ4+0cwnZC7Oiwz+NBnCBUkRtcQs7HnIBUyK4RLZSPSzrK5o6IX/uw
	EVoOnpX1ovzKdW+oB6eeGZ35Jo6184e27KvXFjU/6+BGs1sLaqTLpOxAEgcLpyI+hA+r7pugtqy
	ZaAakrOyb5nG3FZDYbDUgGAXlnMY+dQ1QIfGn9QRmDl8cqkYqqyYvwaVUIaQyzCr9+HcZb/bJvO
	udMwTK94Obpt0yblI90Ah8wHb9nh7ukjlvbCvBRswNXyzFCNiT2d3bIgiBoz1a9FRLQOGlmiY+8
	aXb+zcAVeaLOUl5vxHc+eHTi9duLuaAaFwpqXmpCoSlftZM+Y5P+bjrO8l3if1NnZcv0ySI7YAP
	5eY/9Xktc+TV5FdECHOC8VG4C1p1WpXgoxXpG9+FD/R7QNFUErG4fy9gEYI6uvNXju1naJ19hMD
	WFPfZ/ZFgU4nHc0Tp/Md31lqv0LTz1D4Pzk2OEU6bPzBKhhoqRUAPU5VkZnrKE
X-Received: by 2002:a05:622a:608d:b0:516:ca56:a44d with SMTP id d75a77b69052e-51a5178907cmr318181201cf.6.1782716527051;
        Mon, 29 Jun 2026 00:02:07 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df82692bddsm300651096d6.43.2026.06.29.00.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 00:02:06 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 3/3] luo: Update serialized data to use KHOSER_PTR
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
 skhawaja@google.com, kexec@lists.infradead.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260628001114.1869564-4-tarunsahu@google.com>
References: <20260628001114.1869564-1-tarunsahu@google.com>
 <20260628001114.1869564-4-tarunsahu@google.com>
Date: Mon, 29 Jun 2026 07:01:59 +0000
Message-Id: <178271651966.13502.2620034351625890943.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1514;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=i8hMeTOD7PlXYKXCkQGIEVry2kHEdap7Vv1D92UaDwg=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqQhhtIYYuZBg6KJbH62WNctwI6mdsZePcCtfwN
 44MDknREhqJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCakIYbQAKCRC7dyhM23N6
 3h/YD/wNczubLTbms0pFp3A2EyjJjFEM/LlM1mQL5Mhx3WmXPxHlAJnaL72I+6yofWcwBajg5VC
 ernzYQ9l4uKEJzGRufG4MYpNHUtkTOs3Tz2nl7q7sTrmmWxoWj6EIZKcbDEWMRCns1bD6Vwnt6m
 a60hANaw9vrEwDmawr5obeIpzd0llmmSE2E3k3O90f8fY58rKkrqyEKeoW3Mi3gOJv9e5PzZGsQ
 s8ilIjofewCeCXV3WT9wwl4TKhiNLel5hY0yIlSCQhJ9a9Z2/Mq/010UoEuu3LTs6IrV13bXZ0r
 lDwx70HJVLinpsyqDu8duUaN9Hm8h/m5iRaaoR7zX6Dhxkjv3laM9PzwHNf+YPvslIA33JdnL+K
 PP0WCurgePElqGDXZdMrbV1lNZgbAhXq1YD0/IrYIoNEqyZh/n4wJKlsA8G2kqUCdAmzqKUSuMf
 zwO4ok5vooB1vI79jbSk57ltu8iWxuUcWdxcdyy+Kwp5qzR0B3smYZe/VOexN5lUmb9bIW03uyG
 IQnFXE11wh4D7UDXUp83rP0xZetlhhueDiIY4+x2MIMtChuf2L6K3F6yri2SVXDZOQM7begNd1P
 dqfg2xV4Oq2UD31U+CAGg7r/NzfOxnBDmcJhrU8QzCfxECfORWkuukH7bl+PlBtU20Mc5dliL7d
 mMeCz6aR1v1fQNA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: zd6qmzwkriurhr83rhy8bgzd4zfzti8b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 28448120002
X-HE-Tag: 1782716527-592075
X-HE-Meta: U2FsdGVkX1/NDNlNRgIdJdnmE1ZnSupeQZbUMHDx04HQMBdFRIRjUuqw+cylOIxu7fd/6K2JM7/0dPDtqRzKfpwyFfCBgoBbbZNInPeBVg0dTcF2mgv5FNE24dytCGnHCXF5cYSqR/jkPHf6AtHMlb2DtGcV+VUstNAm7knqCmK4Zn5Dcg689XIzCbU261pilARcsVHA2YPyMh3++q4hMKpJU9UwS3SPGgsMWBLkq1XUkU+zwpbkKePA694hx7chXUVPfpTKzvDfdrEwDarwNM6q2zhTxuZ2TxsiZav/qMnhelj0HfLQro1OPdPsXAHwnpqZ3UqOJlbvkr2wCTiBw1Yrdi2HNDIeKyFhYb/1mq9beL0SgTpoC6YQSKKDeOUplaB3cC9WQBLAYvet6aPqEOq+KWSTDKEhhJy3X0nMgA1zJa0MK8EzkMOjCXXF4p6ARZM/vmnQOineZRpypfTBQNqMj4mph3Fo4Asg3ahb6bA5wlMuXKdUYOjeXe36EawRAn6ND6D6qGIVVC3RpDXCsjdXyz96ZXzEdkeFetdf8Y+xd2c47FiVshF+pPWQAf3Y3A9tWA+pOIrR8vtdzgsB1F3SAJsdJGk7zaNHRYwA53zyTc22eum4Nm7VQPwzkCKO1pSGmGQISXNSXTauaSWMI4VfPeg9kuT+0esCMGgfPLoWEJsAVyChFryXs2h0JayRiXNLkU0Pa2UNZnDkok6cx9U3kuPfncuLDMpDfgRqam+6xgsSl4SqZiUckxhdGHDXCq1+ooXDwg5LkQG35dizD2Pz674rIooTRxUi+cUHh+hP9odIZgZ54PaZMsY5Aeek1PkQFZSOxXt7NmXTV1xPHgJJzv2AiCtuI2MNJdPUTz1ROtNF6OS+KAq9ShLx0I7uJ65JYklz8XxfnnL1Xq/pu5VYjoQpC2hAxVI/FnccFKmbPwN5sfs7FR8Jp26WngQ8G6LuXDxoU3/8n3gQGku
 CP1IhXUS
 Mn+zWs1jodesb62osP8tzCyChLHS5HvcMrph5uzQIgv+wlUWBppiPDpeLfaSdofb1Ugh6yVy4REA6G7uj0GLEqw+Hggt278tvsbU8CuNduFmkMzSkPshjpxMWnXQr00vyTA70RvTc5YafIzTxgRFRni2Z98SuzV08lJ/OkV/tpHQIy8CnzpThWWGuKeDjBsx3kyQdMEd5VwTT/rmGIeTIGgUiWsVcMCu6RWwYZ+d7okOAXxHKC3621UbcpnkfSzd0BOjs5YrC2PGLBxEtTfOThuI92zu7JOv3YlQyp0Sh2G5aETlNnX/wS9A9BPECbjO0Ig3P6Q7ik1JOLFpSyJEVsy9/glxvX04hrWPrFiPMA8s24F0a2JyjeXQ1NIC6dzKf9W5NYF7fgO8e5ZJD2xHvw50xDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 00:11:14 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 288076de6d4a..9e78625cfdc1 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -89,14 +90,14 @@ struct luo_ser {
>  /**
>   * struct luo_file_ser - Represents the serialized preserves files.
>   * @compatible:  File handler compatible string.
> - * @data:        Private data
> + * @serialized_data:  The serialized KHO pointer for this file

I am concerned about layring violation here.

LUO is designed as  a generic, opaque transport layer that promises to 
preserve 64 bits of raw data. How those 64 bits are interpreted is 
entirely up to individual clients.

While some clients like memfd_luo will use those 64 bits as a physical 
address pointing to KHO-preserved structures, other clients may store a 
generic token, cookie, index, or non-pointer status. By
changing u64 data to DECLARE_KHOSER_PTR(serialized_data, void *) in 
struct luo_file_ser, we force KHO pointer semantics and layout 
constraints on all generic LUO files.

Clients that need KHO pointer serialization must cast that opaque 64-bit 
value to/from a  KHOSER_PTR  within their own callbacks.

Also, the field descriptions in  struct luo_file_ser  are no longer 
aligned due to the length of the new variable name, I believe it will 
cause warning when making docs.

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

