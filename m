Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FCAFEC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 08:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3616B0005; Mon, 23 Mar 2026 04:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53A26B0088; Mon, 23 Mar 2026 04:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69826B0089; Mon, 23 Mar 2026 04:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1A8F6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:57:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AD61C329B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:57:40 +0000 (UTC)
X-FDA: 84576724680.21.F364411
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 779291C0002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:57:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmUCiRXB;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774256258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoSnYm8ILHQxjCikTT94jJ3LR37Wr+qWbDDoXl1YpDA=;
	b=MEGjVrS1LMUIStFKanj2UFmMdhT88s/hjMXbbAUd0/Bdb+jqf5a6qWxIhJA0K76kOxFp88
	Cut2wAe7aidUow9VPPkD69l3zYJxMQHW2/dyNktTV79bUz8CtMjld1xT7ZyHQ1bhNMxmYl
	X5Sye8wjsjO948/CzAOyql2O5Z82Htk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774256258; a=rsa-sha256;
	cv=none;
	b=3wxzCS5pO+Tw+1fs/2TR2lV3HqXovnptMsngDbEFzfIqzVqVokjGVMOXI+ZJRE57XvXPuE
	HrxVg4Zhjivfwq+4XWMUMwAYVOmmLvEKjFO+rzMJmFQeRJIeHqXsRLLCJ/pP8SEEFO8y9M
	4AkYjbIJ8WKAocBYsrAacp54lHqfisg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmUCiRXB;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89B80407A8;
	Mon, 23 Mar 2026 08:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D97C4CEF7;
	Mon, 23 Mar 2026 08:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774256257;
	bh=WZyf2xiAKYvK2Ec6h3FulbZi0N72LmUw6Sye6WHrtoo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WmUCiRXBkctFQvFSzTPq0MFCg5YIRnMzG3Rsz/f1ycwn16YiIBKU+QEI8oCrjyGA4
	 7nM4Lb6g819sBGtS+LNVFO7kriE+a/aEErWtdKAVD43NPB1VIwCBCPEjxR3w9+KSxx
	 rj9g8V6Lv9rzpORfbi+5K6I/2AwqR5zKnPWiRAokdEH1MhCPKe/2ccDVtex93VMUQ5
	 1wEmqFXdN6XsaeYdAjzON3YLOcP55uNgiSiCB8ZEaIOTWdvfUYSI4pC0+KzDiG87sc
	 Vx+DUCOuZt219d3mYTT7+GsDEHK7VC9hJ43ogoRrVIZV2IIDTQ7uB3Na7gUA2WHM6j
	 0SCF+N7JbD0Sw==
Message-ID: <f5b5758f-d874-474e-9867-9982d3bb44a5@kernel.org>
Date: Mon, 23 Mar 2026 09:57:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: update outdated comments for removed
 scan_swap_map_slots()
To: Kexin Sun <kexinsun@smail.nju.edu.cn>, akpm@linux-foundation.org,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: julia.lawall@inria.fr, xutong.ma@inria.fr, yunbolyu@smu.edu.sg,
 ratnadiraw@smu.edu.sg
References: <20260321105814.7053-1-kexinsun@smail.nju.edu.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260321105814.7053-1-kexinsun@smail.nju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aw9zdoqxe1hppb8shu8ynp9ghebg9iwp
X-Rspam-User: 
X-Rspamd-Queue-Id: 779291C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774256258-881048
X-HE-Meta: U2FsdGVkX1+3iW/nlO10aJhHeK5Z5T+lxI7fcVapvYPXwcXQ6tv4t2WR1jzQ/pgNfdQWNkrA0L5GSUMxWxJJwdc8QZBKOGPaj9YnsZv2GQX9eZIvZqo0i9Aiu1r/GP6/YBJv17qoIs286rA9FvrF4a8mknKYRYFiMTyaciX+3F9WpnXeL+dHMkzIozf8vhDqzLJoGHpwuaajTHMFdrVUo8010o51j6Ekr8TUx0LrhpARtC7HaFCTN7EBdhFf2/k38w4lWARzwnhjHmkDHE7/1JVf5NmWlOHNbUlv20+Y7WrolOip0JIXxGrRH6a6cMQQaOLwOmqcuEN41XAOgbFvgXE8Bg77MbYn27iH7vkWIXI5BWL6HQS/oRbKQXJVFaF+7Hu1dbRunIFrybvG6upU54cdO+114hS4vjzttNxws2sy0yb22q16bbcVFQ5o/0jfZ/gy/wGwN2fczOSGwG1Pn47FxrPqReFa9IhjSacG4/FlaO1oNErNYXDRmH1yyqjQcxPWbanxADOCKADLTb/avyAeaqjdGxdmw1CWwTuPiIFbuepxthBMeTV/r1e+pu4xvUroR9USp7qA9URH4+TdSuNaXsmvJ5wzk5o5vaUEnJXh1oVKPkaZRj4SD6rvu9vwgM5fwqR2JhT/1XayrLDYw/3AXn2p+OYRtZiWi9P21CDri+PXXANajViJvGVNwntwYHWBdn+2PwZ8KlcsL9gkpWWBGlm4WvSV2MreVIS5VrZa42tOxUOQp3F3mFpygpubmXxj9xQewgJvQ0ieBErgNdUxr9xp5sFi6WNFqZgqh5kZAQC44m7xojgdyXix6zbiGSv0D0b+YAyaQ6JCYNi5/PnLbIrkYhe55P9eack8IJTiCIH6gGyaeKmwKa7vJI62T6qQ1F5nOzm5ggUcq7DppS9RvCe5lae+DKU1mEoVWlJho48eiPO6mnm3jA6yncFwJTkO7DrC5Fxv1zJoqxy
 UzKtL7Dl
 68C0PBZAQDGnvjQCZYqwhDwcZuWMyMf1OX5zWTE45YGqF8JPMupGmZ4CqlBcL6b8gDjpkgQ07E8184gijDTkw7NFWLZ3XfaoGNpCjeLiQV6MIUMc7Ek1d0wKlEw/IxgkXcDVxSFE/2yEFPr0f81sLV1prXq9QE1KZN7UFc4nGsAQSDaVQoZBk1aw6eUh2xgd+Sg+Qv1JwWLtzmnWvrR28bFcA3e3v78Jzc6JihpO2Z/m3QYy7RCNaOBgipzIgcFfEm3OSLMAyX8X+OLHgBoR+Xzo+q3+TWaJVL6nJeKrE8XIsMIFdO9CDwYtNLJn5YHKzM28cq6BYZln/fT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/21/26 11:58, Kexin Sun wrote:
> The function scan_swap_map_slots() was removed in commit
> 0ff67f990bd4 ("mm, swap: remove swap slot cache").
> 
> The three comments referencing it simply noted that ->flags can be
> updated non-atomically by scan_swap_map_slots() to justify a
> data_race() annotation.  Since the function no longer exists, drop
> the parenthetical reference while keeping the data_race()
> justification intact: ->flags can still be updated non-atomically
> by other paths (e.g., swapoff clearing SWP_WRITEOK).
> 
> Assisted-by: unnamed:deepseek-v3.2 coccinelle
> Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

