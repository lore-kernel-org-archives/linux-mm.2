Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59011606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GKfDVUk/
Received: by kanga.kvack.org (Postfix)
	id 7412C6B05DE; Fri, 13 Nov 2026 16:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1B06B05DF; Fri, 13 Nov 2026 16:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BBBC6B05E0; Fri, 13 Nov 2026 16:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30A546B05DE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:37:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FF841A015D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:37:42 +0000 (UTC)
X-FDA: 85431407964.08.4AD323E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB6CEC0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:37:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GKfDVUk/";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794605860;
	b=U8kkuzdZC4WfShnEzFKcTNaKphz6NvF9SRDb7zO8wqG4b+aqdQCcw72QR0+vfETgpeNlxC
	JL6gADWVG0DXHCKQKm+sco2lh4tXTMeSmx+pKoUpzlHzSeOVjmekooASah9JFV8y5zMyNZ
	gnl9u7zVvoyJTUQvxscm0SivWKo4plQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GKfDVUk/";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+XHBJfsKWVYKfgLjZ603k1s2f+H9r7H24RWVMOLts8=;
	b=jFCPvcVrY9ynyAfnPLxBnoRB4W4DRyMvB4TG/5PwCFPJt76y7QjE8FO/GT6u30OdPJJP7u
	W1UBiIQJzkCM2d3DZqG9BuuXUdue+1z7oFEoPCSgcYxYCk4aitbwFrSGA1bp0n4Ei+oKt/
	XOhb2gMcBO6GFfYYQ8HarlTgIHqiuLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 577F462199;
	Fri, 13 Nov 2026 21:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFBF1F000C4;
	Fri, 13 Nov 2026 21:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605860;
	bh=j+XHBJfsKWVYKfgLjZ603k1s2f+H9r7H24RWVMOLts8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GKfDVUk/T9FbI5bC52KuJOS5DdrDW1fG5ZnQ6ig4J0d906uYapCBBuSIoTfTB5Ody
	 Yutf/NXD40ezdSjlV2SC8BcF1QYvgJhTEo4jmb7V+aYsnms1gk7TICFqxxTLiMBUhO
	 jkZYeymStRH9dX3a6XFgC8elC9xVf1dCSjFPJG1xu0NrLJUt+gYxEkiSaoWGiZurH9
	 F0ZpKjdw26lfWNdbSDNpCgBUTmhD5XP904pnIBd6H+PczTdkvf6GLvxDbiG1r81cvC
	 Ugd0o644Y0ZuWIBbnJxMdNwHypGL2jjWGR1+tYo+59MQWaTNTheYKEa+ZsVQkkJ2dO
	 pogrKP8raIMOg==
Message-ID: <d7c9c2c4-0c33-4a65-9b42-d7fc5e972b58@kernel.org>
Date: Fri, 13 Nov 2026 22:19:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, kas@kernel.org,
 dave.hansen@linux.intel.com, bp@alien8.de, rppt@kernel.org,
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <69e27ce5-8378-489a-ad8e-37c364cf63c5@kernel.org>
 <179460257810.482102.3687220421358656606.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179460257810.482102.3687220421358656606.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fpgpzkrpeek8c6dq6tkz9hmyp5uxs83k
X-Rspamd-Queue-Id: CB6CEC0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794605860-680632
X-HE-Meta: U2FsdGVkX19Lao/uaRVnntCe0XJ0MXfUzwequtUxjSzESyHzexc9Fz8y1LOa96O9jXB7zQFvojY2MAAZcWtOc+6b+nNLM/w9wqbcoOtrhqabzjAsa/bDbSzTdQq4BLxY37Ewg5YoYEIIRvo8m9K7QoJ7zpYotaTHzHzEUkVduQzM98cjCwAxzOMI/BEYv2aLl/i6yM9HwQk3upF1000748ScGfsjff2OYSYnsnTHf/FOTdHot/1DvuYLzXf7wM/MbsbZc9E7NkSydFe7vNqqGtC+jyDq+SXhuiQaEXiOZVx/zjpvswG2WdqJrJS1fOzwOsj977plx3tCfi3Gnd8TznCup8f0zEXsjdINqw8Cd1Ug+Kv+YOiIVKaVbKsMK1rhKkBlnPHPAILxPUPZmL2lrwesvGMNZQY1dLD2Xsa3AnSG4l9VwblMGjmXnijKCSZcE649QuRIwyhVzVuFUr/RUEbc2a7zj1+a5UWkapqZSrhPHA6cjXL8QoBgBf8NW14NoZlZm/5KIaWFarFrCQ2YFam+FylxmAa3ckVRG/uB9UpjgrRlciolG9YTLwzzW0GOCqe1BH04HZrNWocL0KY+Dlh21ah0y4TI+6HsRU3OOi6zN7IBa+xCZwebAFyYeE8pEIyzpzsI6X2xhXICk8rGTY7KOD/ltTkU4M31w/jeF6lXnAr11Duz5Cjml4Gqo8DgnWfij8oe0ie8xGJGGCF2fbM7Qb/8nEuWHZ0paeN3f8ZuGdgtY477ercAo6IpEH5EyWIy+gZO4UM9gu7XYdpDkXp24V9vtsEnQJQ5bqRMnrvA8oPQptVw74VKt7vht47xxMIZ3j/IS0mbarIaNT+j/HX2DhVJNanfNpo+aU+qOgsIXeyf36EXPzGRbcePpE4HXKh4R5ZPnjZnQj9oXmxxY4UqZd+NDmkTfdb2T5Hk7yQoxdpt/wKFqjO6oImddO8MrmDwGiooNvi3Xk/RI9k
 zVa6d5YT
 lxUj7VMo9aN7RTHVAfrao6vlpFnABP6eO2VVYfXS2yGTWv5fa6QTc9R4epTL76wZGOL3yxd7K7Xus5FfHsl93b4CsOaCzVFT+CxEl5/Zradwf7hWRwZGiRRR/n5FueY401mY1g3CwyOvlCrmEiGgM1NQMtWKzAuTHmd7jVXTv6nEveeCYieYDAvbApxJS4Ahe18c0rVjXbG9CJfI73w+DYnHScPbLCjJm3KWQCiEXaHzkTS7RM93TuYwIvbaNz4QU7fwZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 21:42, Gregory Price (Meta) wrote:
> On 2026-11-13 21:03 +0100, David Hildenbrand (Arm) wrote:
>> On 11/13/26 20:55, Gregory Price (Meta) wrote:
>> Cool, so I can drop
>>
>> 	e27dc0754e3f4 mm/hmm: refuse shadow stack vmas in hmm_range_fault()
>>
>> :)
>>
> 
> Haven't seen that one :], i suppose *yoink*

Not posted yet, I'm preparing a bigger set again, but I'm happy about anything I
have to drop! :)

-- 
Cheers,

David

