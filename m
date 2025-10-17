Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27BCCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3388E009B; Fri, 17 Oct 2025 10:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09AC88E003B; Fri, 17 Oct 2025 10:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19F78E009B; Fri, 17 Oct 2025 10:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0FD78E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:15:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E0DD139B5E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:15:28 +0000 (UTC)
X-FDA: 84007803936.23.C9A9BE8
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf14.hostedemail.com (Postfix) with ESMTP id 06884100017
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:15:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=tdvhWsDN;
	spf=pass (imf14.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760710526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXKmsIldz9QqYvJfYTeLTtnXwnXEkz/LZjkPfMe+5tU=;
	b=e6ng0Y8rG48mLtlQTJGK/T1W3Ardt3qJFQYQZjk8Gg84qA7S9OarkfqrKG32CcDznQGx8S
	0TsWBbsjsQbY2GBg6mdarExismPghdmT9JIokuvr/J06/O0g6lCTGrgTbg+srADVv1hDSu
	x/5BiQv+6T4MyNcXZhBJDjVHJRflXzA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=tdvhWsDN;
	spf=pass (imf14.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760710526; a=rsa-sha256;
	cv=none;
	b=XeNPjDIwAEp/EHXV7RC1Mf+fmAYirx+Ml11M3mroxQ5w9DHeFK0RLiS2Y7DsMIEECH32ua
	dfr5/f4o3QAqFr2CBeQctbrTDdqfvO/bpb8CYjbMzYIR7SCLh4XQjupeB0QJxx5DBrGrt/
	mxSweeAM9C3YhdUxfEnbjHzNnd8cyt0=
DKIM-Signature: a=rsa-sha256; t=1760710521; x=1761315321; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=hXKmsIldz9QqYvJfYTeLTtnXwnXEkz/LZjkPfMe+5tU=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=tdvhWsDNZNEBUQVAGiA636NnpXjvHTM0mSiKJ7hu0tD0wLe+t5u4QDuvcZwAoljucA7Bs2X79ohRhxiyDhYXzpNV4YUowA5rVY1X0FCI9c7RK7esjmL+/vtgzzzcejrku8m9ovqqTZpd0AFTCvDuVi6kBmisQnv4io5unuFgn8Y=
Received: from [192.168.88.20] ([188.75.189.151])
        by mail.sh.cz (14.2.0 build 9 ) with ASMTP (SSL) id 202510171615201074;
        Fri, 17 Oct 2025 16:15:20 +0200
Message-ID: <209038ea-e4fa-423c-a488-a86194cd5b04@cdn77.com>
Date: Fri, 17 Oct 2025 16:15:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memcg: net: track network throttling due to memcg memory
 pressure
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Matyas Hurtik <matyas.hurtik@cdn77.com>, Simon Horman <horms@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, Wei Wang <weibunny@meta.com>,
 netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
References: <20251016013116.3093530-1-shakeel.butt@linux.dev>
 <59163049-5487-45b4-a7aa-521b160fdebd@cdn77.com>
 <pwy7qfx3afnadkjtemftqyrufhhexpw26srxfeilel5uhbywtt@cjvaean56txc>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <pwy7qfx3afnadkjtemftqyrufhhexpw26srxfeilel5uhbywtt@cjvaean56txc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH: RefID="str=0001.0A2D0333.68F24F79.0006,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 06884100017
X-Stat-Signature: ypxkggx8m5xy5wh3cxiik1hnpd4mo5pw
X-Rspam-User: 
X-HE-Tag: 1760710525-753577
X-HE-Meta: U2FsdGVkX1/ZpHX3l6MrNKMeTlIlW3KFRpBwWQaT0BVhZC+GsoJzbp/VLkTyvLp1lUE4NoEXuqiKGfY+6aevQaa6qiOyI9gIPxSwjlLnIjkjANjzGi5Bb1oNrBA10CZtpjS9hQpUgakL7GBek+1Ch0bAdR5wAcLEHl6iwXCJSE7sM1CGiKzI7Zs0Z5mv7U6smVI0dvbCACOFvyRPUUExW+J3PBS+82gSspQMB4PjbfpqdjEQRo0ZR5PT1tH5uHqYtinDgWMo6KGmpxljs1zFYUOfd7xuXznZYG3wwmKKhgRBeXOHcKA47UP/FcTpJ7ENDGF6N8Hfmb61eNpCPIF4OqPmRpygfxTZ/auvrzMvFHWXz4j13+5HMihOmgYprYVr7/k2cT+GFjwUa53ApPF4oTQusTopvCP+VgURYKh8SSL3FBux3y8hBg+M8aCdPybo36ogOx9Z+7r+yNTMBK0Q7/KnLzNEdWa/GGtvUFC/a+JzP1jp/aHINV5kEsbqtDiagLCnT+1Tdg4QUsaMzppRvwHfGtuPdl8B6nkZMXCDGzUIYs/Cizapj221NYK0Av9wtfpJWgraeAsm9VzGSnc2cTz4CTxNNQ4aQlkAx4jpZqmdVYl+9yaULxAH98Vo/z8hORA1KDNMTPNU00p75kWQOsiVKXRHLeV/qT6/wtRRzEOcwqQEnpXdbETQEwalQa52ZzZ4fomdhdIHoDZYc5ZEvnp7+6pdJGNq1LhcUFgG1r7Mn2Ow2g1B6Hs91FqGfk8BdE3XfLm51avV8lHbg4bkSkrkmunQFP737uoLOp2b2jRYqw/jE09oI+aYimg6KiGoQfpMtfxNnQylYLIq6zJYRX4qDhk9ifKpr283325wv/ljjdVSDNBp7wzydSlEPResdBjm2hwOpuW5xwwQlmbIHaReo0lA5SNtU6cJDSfTeVvmuRjYsxtQlp/wCpv1PE+/h1MtL7o8OB2HGzU2Qye
 j2jTRub0
 p27NDkmAsDCCDIiff9An3N/FAqXr4Eem3OivUp9iTOTwmSUOxPAR4jV1CgMyWv0i9gUELt7mfSKsM2L/FfCE96NXAvs5owtAxTckNx8nVSBmWbb6frmcLRhz28/d+rY1Ht0xa7aueMJgUNotifyPNTOOweCy5waMaKPcRnpLv+z0OQtzsjoC9a53s06XM8ea9spycj7K1GBiw6Ps9oixOGLxWFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/25 6:02 PM, Shakeel Butt wrote:
> On Thu, Oct 16, 2025 at 12:42:19PM +0200, Daniel Sedlak wrote:
>> On 10/16/25 3:31 AM, Shakeel Butt wrote:
>> I am curious how the future work will unfold. If you need help with future
>> developments I can help you, we have hundreds of servers where this
>> throttling is happening.
> 
> I think first thing I would like to know if this patch is a good start
> for your use-case of observability and debugging.What else do you need
> for sufficient support for your use-case?

Yes, it is a good start, we can now hook this easily into our monitoring 
system and detect affected servers more easily.

> I imagine that would be
> tracepoints to extract more information on the source of the throttling.
> If you don't mind, can you take a stab at that?

We have some tracepoints that we have used for debugging this. We would 
like to upstream them, if that makes sense to you?

Thanks!
Daniel


