Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 257A5F94CD8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915D56B0088; Wed, 22 Apr 2026 03:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4C16B008A; Wed, 22 Apr 2026 03:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B40B6B008C; Wed, 22 Apr 2026 03:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 670E06B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:19:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E5FCBEB6B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:19:25 +0000 (UTC)
X-FDA: 84685341090.30.6A8D4E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49A9E140009
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:19:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqnSDKZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776842363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wOP9Y4U3NhqzjMaeXHHD98A+QLvYzRrmFGAUaPAUeM=;
	b=RctEl03T40hGH2wWfh0ZXK3P50XJo24kZBeigEznzawaxIiIwCJEYHBR3/dk936N+uRY0c
	v80RpJxIhxily6+dLti97L7hCp5iXcdO181sJbmZWFdWRH/BVjJ3oaVRoRMJsO7B2Vx5vU
	tG1czygyK7efVrWXrmY7GhH8/ZNTjTY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqnSDKZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776842363; a=rsa-sha256;
	cv=none;
	b=Qac+l2vKSR5UMt9M7fsNzDSgjb2RaE5bdpt/yA3rFTRsddfPXVcxg+4okkdvldaccfhUyM
	wWQ/qTZkNz4oqzPtKyF7MCpC1k+W9sEQ+gxDVat2cw6M4MWxed1QVMVUMuHC+Y358dfgGO
	zCxybJwSgrvAuIXF+Xrdu3S22UWnDSU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 969EA60018;
	Wed, 22 Apr 2026 07:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0EEC19425;
	Wed, 22 Apr 2026 07:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776842362;
	bh=nKXNMWUEo1VbeoPSopgvF0WSPb/NT+EHG7TIVj26WSU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bqnSDKZXCr+H/gliDf/P2yfcsFo0GD7RbPqm3KaiqOx/JMkml2wvyk+2W7leWkEyw
	 OnsDTR67hBQL+XoqtI+Bn/MKyBbS6X3aCuE4x1He9cp28m84PKH3ggGM2Lws/iSUgK
	 dQowFOkvKtNWCY+9QcKX1f2edmhkdWEPK897ZHQazFGV5OCwlWzKV5rqVr68KqvGsu
	 sKSKls9bnMALR5vIui+1PzyCJ/RXfdO3sebSHCV7zcug5sxTqI79Y06RCo8ANqwi+E
	 hZ7hmSKMGRZL5+1a6fZ1yAROJhdNEJGIv9g/uQy5jlT17ajZ7Wu2lWD9yWrfoO7a+6
	 zCrxw8vAXBdFQ==
Message-ID: <272e2d8b-56b6-4d60-9daa-6743c2fa7209@kernel.org>
Date: Wed, 22 Apr 2026 09:19:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add RWH_RMAP_EXCLUDE flag to exclude files from rmap
 sharing
To: Pedro Falcato <pfalcato@suse.de>, Yibin Liu <liuyibin@hygon.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, mjguzik@gmail.com,
 wujianyong@hygon.cn, huangsj@hygon.cn, zhongyuan@hygon.cn
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
 <rbc5ezm4uuzbcfaah6w6em6ndfbhamiug5jmp6srovqsx7u2zv@nvyvigon4hcw>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <rbc5ezm4uuzbcfaah6w6em6ndfbhamiug5jmp6srovqsx7u2zv@nvyvigon4hcw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 49A9E140009
X-Stat-Signature: wms9b3fqxix7rkrd4enwmzhxhnoe6y9x
X-Rspam-User: 
X-HE-Tag: 1776842363-859266
X-HE-Meta: U2FsdGVkX1/VxRx0HiSdRd7PHMSltRPdImIT28sMAWb8d0IOqvccsolUHqlfYty3BdW1Ilfg0GvEFyMi0iUjDviLo8a0HkHAKFEA3T86jsNk9ZbW3RomEmOz4Q1toW4lXQ/eHaR9MDl9mPbs7IRqofkyXsvxbx0GZuq3GeFqx/qjxNasZZXZ8CyZoEyebMSMrhfAIJoXnlBTJp3ozmHquPvlXK+MYnHmIoDezcdcegaP/CVM0TXVTIjfFKeqMUT4/3zIFfFpxPlSWT4iV/btpOx/0S438GuyxlzBFNgOu3vc47ESgp2OsoiYaAQ117/1eKJBIuXlasi5nmASKFgAzT3A7/fBNmsCQAHLj5DDQ7Sf7aKDwwsc/wQHv6MuITHthtwXJ0i59dhSnHepwH1yrFKyD8zZNWJjs2etJv5VxDalrHNOqLD1Do1+Gz90eDCUgtfc1FS6UUKkkUEhSZNZgNKDNFHTgDaDE4VIlsrNMJAXmVCJeW8zZoNesIeK00WUYSTuMq4cRkPV/ueKVgd/jH1VCRkez4envMLn7gorfq4i+n2kuUcGZKLnrNPtkQRp+tmRHe2ylWh4qKMuP4ce892WYUVchKAh38a/Ql2Phnt0sJF75CHWvztK8uyX8WjaZlCA0XAiELa8F+POy8w2QwkpP0SuI93xn7HMWJ8rjJUzCs0r3ZKtbftUfTkr0XQz1eDyTJK6X3cqn4nTG3p22YOe2jLj8YCE7eYgF8ELkQiavgFBuGJ3Q40sMra9znoECwf52gYbd+lmXxGrmS7GPaZG9mwwDeuxKqtTt8xCo+WNcgX21ZLjZpxLQve1Vd9uxVOWV98oMnN32PyFqj+Dh2oP6yY68BG2yDYfblHmRp1OxIT/sysodWpRCPNIt119RZ9QFtvAPIYDE2eWmOTYBDMf3PGk/LX4gm5hBBMEqz608UQssZMRTTnLe7p3u8jgLUJTUCDTeKsvUU4Ibj6
 IjBf34KP
 D0KhvoJhYh9Xhq4ezkm6J6J872IlRgx28y4lQAj0iMCuKK7Ho/QQY0M4ou/u3bkKnvJjmNQqX6YPMPOsKWOpe4NYpunZZZLSyltADBpCEJQkM25StzDQS7XJcPFXI9Bfnx+wPRIDIL2CPpx5CzBFFPvshgNNOEXadR2fdkVrXoVch7XwRrLnY/NA6SpQ5ZDBaunfwXESnlwu1RaeMRpC2RgEVRiMRhyOSD85asGY/dpFR8KjandtUMKk4niDsfkWo1tVikIgVofg6dxVkslxitRSLwq/dCefLIfjewdu3+qBFVApjDsDmz4iSAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> @@ -72,6 +72,7 @@
>>  #define RWH_WRITE_LIFE_MEDIUM	3
>>  #define RWH_WRITE_LIFE_LONG	4
>>  #define RWH_WRITE_LIFE_EXTREME	5
>> +#define RWH_RMAP_EXCLUDE	6
> 
> Userspace does not know what "rmap" is, nor does it need to know. Even if you
> found a workable solution for the permission side, this is not a good solution,
> and it's not a good interface. 

It's horrible and I am surprised this patch is not tagged as RFC :)

-- 
Cheers,

David

