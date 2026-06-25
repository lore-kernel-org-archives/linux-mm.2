Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BE9CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E4C6B0101; Thu, 25 Jun 2026 03:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36626B0102; Thu, 25 Jun 2026 03:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73206B0103; Thu, 25 Jun 2026 03:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7ABB36B0101
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:59:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3767A05A1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:59:36 +0000 (UTC)
X-FDA: 84917685552.25.530FD79
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5C55C0006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:59:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782374375;
	b=n+Lqo1DTJvDATlba9drZppOljU3eUMYIk3xOjXuwvcrabewrwH0I1/QFdtuNTllacFnuIH
	p158VmFCiRNhLI5W+0MnMS02rKmC7CcEFbpiunCZn7SrJrlak6Xz0vR/3v2qcKifA2YNa5
	G4Vbrphd5zJQ8lz62To63x1bASedLrM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782374375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1fYxGHD6DT4X2psr6GDKAfY+P9HarRK/lKaO06sgXSA=;
	b=mhlPwei2cNE9Nvyr7UGxll0K3eYiwBqvs4G6D/NldcMCANnd/OPH60Xhvh/vlSxfQbD68s
	woQSELeE2p9eExXdt9ZtT4qRscEXvfXDXS3SoH/yEFx6RaLPaOse+12UCXxhQvwy1LvDVu
	kAgKom4d7lZ3my94cXu0Y9vDJzNk+DQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 0DA413ED42;
	Thu, 25 Jun 2026 07:59:29 +0000 (UTC)
Message-ID: <5ab65638-46fd-4389-aa4a-ae66431e1270@ghiti.fr>
Date: Thu, 25 Jun 2026 09:59:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Nhat Pham <nphamcs@gmail.com>, Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org,
 chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, chrisl@kernel.org, baohua@kernel.org, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624075700.751467-1-alex@ghiti.fr>
 <CAMgjq7CfMp_7bhDWirUmxM0pFzk6d9in9h6wuHsMoeUu-+TC_Q@mail.gmail.com>
 <CAKEwX=M4A4kAFS-Fb=toAK7e=mseVc191_2r7vTrMiJnyT9+wA@mail.gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <CAKEwX=M4A4kAFS-Fb=toAK7e=mseVc191_2r7vTrMiJnyT9+wA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: 0
X-GND-Cause: dmFkZTGoViW0atIucDcgd8kIviKbaMj713QP8g2MW+DhFBMfHWFFFBB2Ck7sHdNrIeoxhFSofWwnFAmov/1qegUMNTI6Z3r0RNmbySCaU5bp43Gmb6zGh1uDzo966f2GtoRpQIauG9mEFOCMcm7OylNFYDNJo1m4243mw1/v+Afgly7NJGnQpvVQuYnQNx0H8D34PuVEIbA/OUC99LKqlru/Ym/uRAWGGmrjyIxEpoyH6aOxCiPiECeMPT39xIZoAFD2hUZzpC0uemaTjAvFKeMxcZYnCQdSn+EJduPyT9Ku777tM10fgSLm/+29g4NVHBPAhPSoiX9qPhkCuJIs8hrM+8yEb4TESYaHsE/UNnN3zzd+WK6x4iR3hFeNb32M+cCDRuQFGWINXxYE0ae0QeEHEHvJ2v7gkEZCDQbocaAkN7mX9rlqLTU/nxHySvdAZpbqE2UDcsly6pC1Q/Jf66NJxBAYQj73KnVzE8ddUK5lE6iRfI3Tqb2agfY1Qh7iwSu/3ryVuh2G0dC7+gXObCkUHWRgktRvc3PiL+5RjjdLIWszjfdNIHzOpDEeaPUHIjmbdHXZ9oUDZyqp5cboIg1+1pB2AAf+ZAOtU6Sq57UcEV8Bv419NxW9zbCpL4CSuHjfaNoqccheLBnreEBOCj11fZuXfY5eqwJnWX/Cxr0dtfatxQ
X-GND-State: clean
X-Rspamd-Queue-Id: D5C55C0006
X-Stat-Signature: unjn6pbbmxhtsdu37gy8ftfwicz8e664
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782374374-695059
X-HE-Meta: U2FsdGVkX19zWgK0eFJLhu4yf/KzgQtSdSGev7ng/+6wyDk4W+CazLUYP0eH7nXezawViENALZjTNqMe0knf4DTvJ0MZ/xvzLNlTx3I6c2Gd4awnnuJ5yUCOfpNMAeiXzxh53VYGTVwgWtx/tS07QUMCT+IFPW9h4n8Jqsha95pXEumCikA6q3CPNwhKkz7w+llBgFR7IqFggI36BsQsBosRB+EOzyZWBS7f1VVZu/uGJiM8Ji/uTFrTZLT2PqQu2a/pFSFzasLcRXssXPTFuf97EzcA/2N6d10dG8tTjdH97+Xmcy1VTYFBe/cINYTeAeenS9iR3PM9m04TzbZFiXLuhaGSDbhMWanaSL8i/1kFebOVF+5hnS713tCPfyAZQ0o1G7yYdoDHOJqI2I0F3+nCIxnRK6W/pUttqawDRrZa7RT9a5upo15XWMvkrg2ZQCdc/XsnSSknM+mITTGWYJJ344SoTHRmXE0MPvs6leBLoPq9iQoKCBq/K7UkBoEkgbQ24jvhNO57Z7duleMe1o3XF14NgA8qeFzKDq5vUpuWQQHsK6QbxpwhyTRJ/JrizgtRDbd/mzw6U+ZVs+JClacQORTCBS43C9l1ARmAGN1rLXryyf/Te2yDuzLN6t/THU5w7AAuwxam6PoftKnNahLilndzaGZWMRIbx6qhvgWsoMRgYxBbfp3HmuZQlKkCau74Xf4ViUR1Nw3LWqgvdwO5ajoz5rCBCxgTXBa6vHa6dKYp9RmKaxseyAPIWtuKh3sseMhnuLA1xO0UloR5eXxpDM8dno9er1m11RygCzpm717iYRgd/MaKMvoyqr46wgtR+N4MtzPym8VcZBH7YbxVoOoN5vO5aZYiGZGqDvv699KMkGAVr1S2/2thR2XZ++9OjPE0Yz1kXug7jHuZs3cfwfQSkhIxtx+1ceTKaFiViBn6JJUTIVrygbmCYVj6REKtHEnK6RJQqyyJGbe
 YuoYXAlD
 mNynU7T3XQqn2tQFRLM5IFtK5ugX4PbuzWZ2Fpt5HxJVuGen4hue4ROawFC8Q6hApwn0H3RZn/O8X5bXcJhC6+4VxoEDA8pxfxvFp4ABRZkF1wnpGskZkdMf/4KnAA7su7Or4k02eI427lBsg5Kd6TqMUlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

On 6/24/26 19:43, Nhat Pham wrote:
> On Wed, Jun 24, 2026 at 3:31 AM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> Better check zswap_never_enabled first to avoid a xa_load if not needed.
> +1.
>
> Maybe also xa_empty() when we're at it? :)


Yes I'll add that too.

Thanks,

Alex


