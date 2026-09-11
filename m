Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C93DC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 23:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1DDC6B0088; Fri, 11 Sep 2026 19:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD966B008C; Fri, 11 Sep 2026 19:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE686B0092; Fri, 11 Sep 2026 19:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BFE896B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:56:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B8481203AC
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:56:14 +0000 (UTC)
X-FDA: 85203142668.16.A296AD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B49AA40008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:56:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V7TZybOt;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789170972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDlrTa5ZZtH4lzzh9UJQLR5eKEupJVTNDkxtOBjcy1E=;
	b=4c6x/jiIeoXCWwa2nnrbbmFpIJ8sDK46VaTbkzKYd4v1eOyoZpaTp0hBViMYEvlHMdo8B1
	i2L/03W37hupuVQppQxlaDmF0EpjOeXaGLcwyOR/eNo8vBry+UCy5CecYsNbVjPxbSaiO5
	O+xF8S8zyolhsRXlWqkENEqv6fED3pM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V7TZybOt;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789170972;
	b=yAUavXc2IqRdSqV/OcDigSc1oAGF3b0KJRJ7WCcNEGyOdGk0gTxjZJfclIktd535Cwl8LW
	jXmA8e10kBtKmQbjE0h96OLJ4NvcDv7Re4Q92JHcx8ATT2Ie2RTfOwJ/SL37LDIGx3zdSm
	HFzKjmZ28FXKHrfvIpr6RS+4+aefwkc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDC3B43592;
	Fri, 11 Sep 2026 23:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3921F000FF;
	Fri, 11 Sep 2026 23:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789170970;
	bh=wDlrTa5ZZtH4lzzh9UJQLR5eKEupJVTNDkxtOBjcy1E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=V7TZybOtasBQe1DbZtheFvd5k8G7KLLoawtyEHnlJQBXytmjwN23iPwfu5E8F69yN
	 P5/rkhES4PfwwF5SIoY51aiiekLzMC+JER2JxuYki01VUaRJAIcoLqNss1IeAQM9SV
	 Fustsba/D+c5OOzP3VtwHvyVMS6IJoUq9Ohicf2Y=
Date: Fri, 11 Sep 2026 16:56:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>, shuah@kernel.org,
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip khugepaged file tests if mkfs.xfs is
 unavailable
Message-Id: <20260911165610.e1b1d957e6c73a200b64e546@linux-foundation.org>
In-Reply-To: <aqP7gW98GIiYgL1z@gremlin>
References: <20260911124517.63714-1-jaeyeon.lee.dev@gmail.com>
	<aqP7gW98GIiYgL1z@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: utm44fhyx5gsnwtnpy8ayxtdhowkosff
X-Rspamd-Queue-Id: B49AA40008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789170972-347378
X-HE-Meta: U2FsdGVkX19laFRy0a/amP8XQKAFcrAB+Y6tQIMpORdblBmUq7YBe697RgJSLGmqinfZ6aiWRzwVHFNfYyvkBev7fkVzy+3Bxamh0m7bodgmm540Td3o/oyyDZahKKvECnJhrE7HtLbr1VabYGKXxiaMsMJfRdFXpXiwMNlmJqBHguKftmbHD0E5V526A8WJdkD/5Ca7u9T9tcJRAcLoJj9Ij3Ru0ImH3/bkfISFRjOjjeczvcFpbAO33GlNmTgwbzqfgYKjrQ4JAKsBrgbmVIuzbiOCIn5pGMaNeebij9TnzzB9VNpKzep0bZk20BZBsp6Fx/+fmVAkY+5BcaQR+1WiKdvwi0ESTVipZXSzq6sLgcf9cU0/dDAf3/glB88rIQbS02MGtUiRjsDr/HDy8bO3q0btxStNUp8BDI5sUYA0wI4PJAlTtVmJIUGEt+Sfar0bLEtyPrTQ0yfzHPwoD9hseyAIW7Z/be2GEkLJdwSknjZ0JmkolHwyfJZw9J6gRbWil2VQoWgCP33hRRsg3j9Q2V8Qkjdpkb8VIpjkcHYlHPXp8KWPFaoJI5A3+7doxmzlI6lS5456MvNj6fIcucyRNDrqZDcpZXIpt2vUTiqfvdFmeZaWrCk9aU2B5oeMMlEVLmHgy16donWHleFNZPwFkH7Ll347+J2yTwU8poqtcUgwCR2Z0MEgEoEfc5SCw153dV0UDtyXPXz3u4AWQ+cJXYP7VRyiy6w3rx2Zp8NdYfVqu80ZH/9m61UkaZ2Pf0HCDrLeZA7EERl30uEgxbqOfpkWgpH5wVCJEnW4ES+fPjiH9UTAd2QDHnwHa0u6PUigqYEivUwZ2ULFJt6QJOmCVhPplFJk/Sx6Y09m50PnF8JpRRxO2L+OL1TehAt5pNu8We8OXJEMgcFYgOjtQkdjVq0B2TrVswfO03Le7uD6aftSnseu6WqqALZJpoAIOrffxfOOnuTTiN+o5LL
 d0ozuJPB
 OUqeJkOwa81GktvkMPpANRyd27TKUQrCQcftiZ9WndGHdPxmUir+3ZkVKrF5bCFZK+04bVQHLy+Vwbv6NUDeh6E/RxcwobciWyTftvShfmvLfgnWOmGbh+AQCTfBboS4OKqMojPnSwSuzHRVTqlivOL4MR9eqvc0oD6G4jl3w5pekSAMO+z/9Hn+M944lEqQ7Uol1yJlWQcbVDx9QubLPicKV7kj38BLn5pa03nrDfDDixvGYEU2vzyiD8d6B17x+8jeLdE6S8iqAcn5mqAtRNAlPhv0hLF1GL+nKuJpsAS8xiIxCV9+gfBMgHdvbn4f1XN7Zb2WOhBYOPXI6eeNty3ZbgiagCZ+vE+4/eylJtZZxUPLnAjxVDV2JpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 14:01:55 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> > Assisted-by: claude.ai:claude-opus-5
> 
> Convention is now:
> 
> Assisted-by: LLM
> 
> See https://docs.kernel.org/process/coding-assistants.html

Yeah.  That's so lame.  I like seeing what people are using - it's
interesting.

Also tautological.  What else will we ever place after
"Assisted-by: "?  Dr Watson?


