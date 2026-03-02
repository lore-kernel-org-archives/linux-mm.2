Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 449EBEA4E09
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A316B008A; Mon,  2 Mar 2026 10:00:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7316D6B0093; Mon,  2 Mar 2026 10:00:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A766B0095; Mon,  2 Mar 2026 10:00:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5147E6B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:00:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E9F056C7F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:00:19 +0000 (UTC)
X-FDA: 84501433758.03.A8D0300
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF7612000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:00:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pt3vbSqY;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772463617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OH1lj7P7jvVhknUAZmM+PGKL2cHOdUXpcG24yTK6ErA=;
	b=05XIecdewY7PCVklYcXXrTRPC9JJl3e4xHbViTWDIMFMlky1LTHOz/UOnoPZSa9Uf3m4cY
	90Sl7FeEqdBYVNPWS3Ijh51+quXX16GChgMhXYbspnOkoYKseFo4nck0I/fN7X96C9ITsL
	i1sUJ5jnYiGnJvJVsz1Xmw1bNGEED+M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pt3vbSqY;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772463617; a=rsa-sha256;
	cv=none;
	b=kWE82CkpK/AavDJv6wpSdmTWhE5uN0vnVEBmrCBrdpD8nA5QY7ztGQYynuEvr/VAy78mew
	QMOgsRdOuam+XBC09toX6xi7LAcOvyU3/K1KcyWKUfjNnmqdO4p5wBAacA8JOvSGcy4cBF
	bsuICDVfkklH5VDGN/ZQX56b5dEeHYM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 043366012A;
	Mon,  2 Mar 2026 15:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDDEC19423;
	Mon,  2 Mar 2026 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772463616;
	bh=AZagH7nOGcK0d4ShsTJ7OBfKpbvr94+ayZUnVTTTTc0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Pt3vbSqYgqJtBE8LVSLVc9xKdVb2R2waCtHBeN33it0fB0T+YzNhtCpNHvhjIdbLi
	 ZVX9nUT+5BEOn33jKP3UZOhVITSUr1LaPVMgB3FJIoGryq3fqqmQeK8vJnt8FbHOJ+
	 uMgqpbzLzljVqKwldIvAskUVqntG55PgY49ED7cFXP4F/uZLC5c3Tz1Fq9WE96QM2m
	 GUnYlQFPrVI2u31TP3JhweTHuDIwZCMCiMZNuGgycMsNHqgZJNvKmVg6XA99NVkcDu
	 LU1CegvMVrm5M5+uSGvfKsqGYGZsj3Pw/+7YQJ2WJBI2Dxxn8GxvaVLhcZmG0XB1kw
	 0SsgIKFtCRHyA==
Message-ID: <3ff1e458-7e13-4dbc-85e4-0ee0e7b0f250@kernel.org>
Date: Mon, 2 Mar 2026 16:00:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] virtio_balloon: set unspecified page reporting
 order
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 akpm@linux-foundation.org, mst@redhat.com, jasowang@redhat.com,
 kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
References: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260302111757.2191056-3-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260302111757.2191056-3-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AF7612000B
X-Stat-Signature: s4fpodxwtnqtkfp7kzzhdfj5waiezhej
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772463617-323044
X-HE-Meta: U2FsdGVkX1+b0pOtI1Hd19BphFSRSgaLNwXgaN5jnoYb77ULQTdLDyAHarOrktxr6WtWAbQLPYbVyJ8cUvoaH50JbpEOv8bUZyygf/+zONzuoZx4xW+/51bXD8nllNFfFJV++JpskfKnfdQ5cbAPLofgNfZuKf12PUKw5hyekRTxA3maps4+GZu4vkAmcHUpgBuHVq0Bnba2S+qhrO+UzQPU6nvsw5zBT/o585YhrhMIzu0HQd6+P8keuIuWLnEnLHtjzJY1ycqF9cCGCNn1kLTUovZnAFtbhX+UAilDBf3L14n/0NZNj5FKYuGq16YdvVQC4G4jf2fOrGc/6oq8lRQbicoFNXF3Rar71g+tnQS4Yap9Az+XnJrISYrtNlTssIEPj9kSkcaCPOqGXBE0Nt7BQf9/4G+3Vqo0IWgKF8oaSmj6uWrCFJvBhbkK9L/YFnWk0yosP69RCT5fM6znEp033OUCqprNJr9Ytde3viPpnTEAilOj+//9dr57jCn7jwIFbYfdd+fQ6ifbFYKusozrzD9+MTat71fDuw1YdTYVFJjojrT6gonueMWETBDTdBTZFsVqWPkCuyhKvfwjbOV3bMPl0UoOPjpMqrYdoFMT+EjNO+OZiLn+MZCM8dFdua3e+Mg9kzK4ofG91efYk75X1vc2rHqFbE7eGume2KojzlktB7UiJ+HnCaRDacLAsf3mGWnsnAR32eMNnrflxT/AZAJJryGihfReR88AOQlePqBYUWFvd9kb2+9uJ7K2Y081SQYwwPFTP0PcROs88nhdF4tkTf65EaXkgOnebZvjFr5z6KFR3ziE+p85RCy6IgH1QRm04VZtRuNEibadf0Tlx+JhqOROJEOhhLNjmGOHlzs362gc96je1AkwYcm5YVGG0jDLQLvcoZ8fBmuaFxScj8DVze7WNJeA5gZuRtq58Kup/CjP1KCUuDfB9b5/7p7XU/9b15H2EiHP7Ev
 SypwpNMK
 DDfPNSLpbckY1eI1UZqWUcGoIQedLBOZzfZy4PupctbDO/PotuZ0SshTlenGWWv3AGHKO526ODGNqsGep18kU1tsGMz+OPHXx4+3kMvstn2yzK3Ao8RMa2saMSl9DpMRlHpVsHgWhZ1arCLESKC25RDwc1PCla/KAKY0q0q06U7tp/I2bL6l0H2uOXvTpT8StnxVpn+Vz/FbxYbkhG5f5XDHkzdqS2M+OsuFIfXAr/cwkmj6wPCqDNrsovJ3HVDux29VbczGzqyK/V9m8WeO372F55KnT/yPWeakVCibYvZYdXNbL5DF4MZZJWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 12:17, Yuvraj Sakshith wrote:
> virtio_balloon page reporting order is set to MAX_PAGE_ORDER implicitly
> as vb->prdev.order is never initialised and is auto-set to zero.
> 
> Explicitly mention usage of default page order by making use of
> PAGE_REPORTING_ORDER_UNSPECIFIED fallback value.
> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> ---
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

