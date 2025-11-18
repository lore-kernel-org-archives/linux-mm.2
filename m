Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68D01CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9EE78E0027; Tue, 18 Nov 2025 03:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76AA8E0002; Tue, 18 Nov 2025 03:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CC78E0027; Tue, 18 Nov 2025 03:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A5DB68E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:21:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48A4213AE03
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:21:56 +0000 (UTC)
X-FDA: 84123034632.25.4AB9474
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id E80761C000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:21:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=lDJcrCbG;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf20.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.47 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763454114; a=rsa-sha256;
	cv=none;
	b=wO5NiU8+fwFTtfH2DZGbpl7DO1w1ZxVDoHJSTrhTANz1uCZP/0QGPS56JfXgGIyny15XKl
	/GZQidImkXrHZ6IWYq8Q9Kg6dbmLOcYnVVAOAnAvM+CZNhr04YtmvUHfQbt5LDO0yzxspx
	VahMvrUHVWmkOFt7IMw7d6a5OqCKL60=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=lDJcrCbG;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf20.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.47 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763454114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7DPGFKVy0s48PVy6E1rMZw7G6d6Aqidjr0SNy6c4rg=;
	b=2zTjjKGwx6WbRg91wOh6VKreLEZO4tUv2Vaew+LYFl316Hq4Wn+IcbHnKaQPs0wBAHkwi8
	QEiGZzAVrZcx2CDq9YB41183CpHyYqpvtPbsxWjU/P9bjCVMT9vyPVoPvkOLmKuRrxQlIt
	yhvirIOYIFGI1UBB6yVRWRLK9BAz7LY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763454111;
	bh=D7DPGFKVy0s48PVy6E1rMZw7G6d6Aqidjr0SNy6c4rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDJcrCbGDutEvKP0OiWcrR82AoANoNRq6lwhx93tbn72Yw18s4at9aUs8muSDR3Cj
	 a0hK+a7an92X+eNM5kJT8kFYxBgJO6iifM7PFVbuu0NdbVpICmhw+llx2BjCbW6ntK
	 h26kMM02Pc1xx3YpTuBsI0BAOK9Bs6vQDDCikCB0=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrszb42-0.qq.com (NewEsmtp) with SMTP
	id 57003039; Tue, 18 Nov 2025 16:21:48 +0800
X-QQ-mid: xmsmtpt1763454108thf7bnbho
Message-ID: <tencent_C4669CD835EF1C2ACFE58BB30BA60886BB05@qq.com>
X-QQ-XMAILINFO: MwSgv9IoJFr1DNKAPmLPPGkCSjO832gac+Nkob40cHLFFVFi6viG110AHX/lJk
	 MR9qQ2zKu7uIFRMc0T2nSW+57D3Xe9ulEwPrRvi2gv5kXyOgECUdJZMP6ZFF4dd4F0l4HiQwiRKe
	 DEjO+5Kq4SRUfaM99XGjI6gBcOhYjnfJ28Alr++Rb/wQPQdcmA0MZXEK4V5CKM7+Rh9TLsLEOi8w
	 CSj3lokmibcIMtWKnYaEkT9pDVj2hACBQJS+XhSoa9qnmhE0tWOoz1IPXyKUlXZgCcnPVRkcMi6B
	 P4f1OgVdTiRqfxUzfjAfmYhWBsyNNjY/k6OTMZUVoLgB7+XKC3f4EqkwAjQdQHQ6Hcj4G/1cmSn/
	 jXmuM2D8gELGqM+BoRv/RzhM2hQMX3Z9kOuTMsWVBpimU8T9BjAikA+UibiSG3VjZsDkvaVs6qTF
	 l/LBgYw9bnZ+D9LmrEP3kp9Ryv5SZyMvPZiQevfFPCT+Gs1Vlq/Kv0NxdgRUZuZn/+P3ZR5z+DFr
	 m5SJFlyCfLOfov6ubPg0pZwmpU7/s0Mqc/KEg5lEWXtafAw7zCBOLK8fn3LI8yEpc/COCBSA2Gf8
	 VQJ1hetHYzQodeBFtOdu/TbWi0JZ17Jfh/owuCMAAvl/gGZDlbZtE0nJma+jjBgoxL5OrQ6Uerd2
	 W7Tp62zENKbTQyhmkbxHB47XkK7dlmLfxmWD90aIa8NkwxpUH3+pCKwxeaHNOCL1HsX6TcBXUxOd
	 Z1fhagpZzP48TMF+8Uk0OuFY2TA7OZAn075dA7PKgnEO9nB5laVJTllbXne5INMGGwiO0EqECSBG
	 T45OrFcPAmuOzP2LSGkXuJrjq6JJyC0Ia0N+LknC3nRjexvrnPxGMTQnIi3b2OYiRdoKqC1PqbX3
	 XXW6k1K11kHfw5XS0C9YcKZYdC2ihpP5N8FA//xG6HHbX6MlPB6sCp82Q64e5UI4pCSYTH+fboEt
	 GMZJZR36Wy73ZU0FtKn+Li+/PbHZwWnOw5T6PjoZ4WzIz9zEEW8ZwMXiWDP402DsbRP4oITO/ynS
	 9UtWqZBjwN+45cspLEDMXV/jQM3iEoZy6XjAyNxqrcedUqEsEyAnwSp+X1tpaFHXaB2eVlo1y07i
	 pKFvll
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: Re: [PATCH] zram: Fix the issue that the write - back limits might overflow
Date: Tue, 18 Nov 2025 16:21:47 +0800
X-OQ-MSGID: <20251118082147.2809308-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <bo4g7erropsvl7vulufdsjqlkkbjycaounh2vv4a6urttxvubr@f22z5wlgntox>
References: <bo4g7erropsvl7vulufdsjqlkkbjycaounh2vv4a6urttxvubr@f22z5wlgntox>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E80761C000A
X-Stat-Signature: 5xz8unaw7h5fuphdnjr6r4meqrqeukhz
X-Rspam-User: 
X-HE-Tag: 1763454113-476065
X-HE-Meta: U2FsdGVkX18H6PR/PSYqy7pu1JuyTJFNt0vi2bnG8Z9PC1DZXtcVTIaVF0rrRZyVWqsFwpAo/rs6KvVvF2tJygqN2FVa/3lyZCtGeAdTJRKyBuvETfLzJplDPuyixAviX6SGVlUmFsVTBT4XZdDndXC560ef4K0IQu8QmfyZZIXew5JSqwrHuBEGvwDkra9ON2B7cLwkkMXBup5Qy5jIXQzf5wS9p3tnxWo85mOzfIE9qow+gKJ6rtTJeuczwPUuTMjAdr9UcpCCPNxg0C6zxPdMJGavu8wEFVPLzXudVyLt8J94Pqu/Mv3MwVvWuNm3McbPAq+o4G/h5dRJ4UQ3e27ZoNYGrx/qVUPva273yfa0hPFkBJujTVsGmxHA/YXSPrlL9HJQ327uNrbP27ZV6N4hXHlEPbfEaz+Bqnn0qisEWoHa4cycA3MleJyBclD9E3Rp9pYyjuUXKs4+uv/Gm5IlaHVc/ZIkkFBcbxAPaZrIWqz3UzEkakctHKAY+2rJkiInPVOoqHopKqzvKEzcX616MF61j0wRTdUgBgV1oR9TsEN+LpN5QYZcvhpOil0csg9RJhgXRLUBkwhZvkOCTp/S2GwKyrvpMPL0WLGkGydU6p1Jr2wDGrdjcg4/s8//j9cEOOnViFYcg87hwe2L0vgIhkFFchresD4OK8UA+2qvpM+9kVnnEMDWegxqQi5uj1cJi6spcsijbrJb+p04/wZxoQ9cVFzZZRVNrpQ1y6Nn/DlD4t40rfZ0MzZBHSDwVVvojAuOoKs04MqklY2wiUuT8m2U7aBTLqoahDEg1wG+YgRwSUd4ueZw7xGEDj4gS2NbEtNoCnJwEePZiIf7pdtD0gK2ZsvXWZmnPmOzq/7aHoC9QSz/OnCtZNFEXbtsWA0bi3LOAsPfpBjDTJnWMXZPO0PTYiLr7A9bdVZEzw+BJfAYmH0nzfiZWC0rJsWFVWU6UFe16A5iUIO//el
 nRVxle/E
 2N2oAgAyMy22NQqBkskpkQWRMaenQ7SmuZJiDU2reL1Zdgd24TwSq65Dc0zVoSQBRXB/bPucwFjrKn3SUjqfP2X7RybexEuVhi1O4GbYJhfdj7BQ7/eVzMqGwqrlHxi4hKuiedxAFKrxloPWTbtxfxA7v7cfVJeZtLAC7kvrIczYPrsjMf5Ju/N0ESLnCHkSd1xsgtH95v1oCxGl/ZQGrd1xrEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/18 15:39), Sergey Senozhatsky wrote:
> I really wish we could just change wb code to use PAGE_SIZE not 4K
> units [1], unfortunately it's probably too late to change that now.
>
> [1] https://lore.kernel.org/linux-kernel/20251110052741.92031-1-senozhatsky@chromium.org

I've taken a look at the patch you submitted before. This is indeed
a very frustrating thing. I'm not sure if we can make the change. If
we can change it to use PAGE_SIZE, it will reduce a lot of unnecessary
logic.


