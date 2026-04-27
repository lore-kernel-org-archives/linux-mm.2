Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A97D5FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F666B0005; Mon, 27 Apr 2026 04:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20706B0088; Mon, 27 Apr 2026 04:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35AF6B008A; Mon, 27 Apr 2026 04:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B16E96B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:17:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C8F6140775
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:17:33 +0000 (UTC)
X-FDA: 84703631586.22.6B1DB49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B2D3120006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:17:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p04CC6JP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777277851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gekKTo2/LT+SNr/iegUZ3tnqXkNXcvH/6G+NH8r/jg=;
	b=bHK4zeY2Vx+/wi5gAjvPsyg5wu3EvWB3Ys3i2o1PQJk/h+harB9HLLwkd9sG7ZUVv4Y/Zs
	FoOyJESu220VcNqPmjNfuw5sMNtukjsE9+Hi3uHRqx8PPvjQZMxHedjT0+V4oqcWNoTCqb
	PKVFoDGtRGhN1yos+szbR2nGGJ0aqFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777277851; a=rsa-sha256;
	cv=none;
	b=0Xkkc8TTVagqjq4LkwWanQcBUxs+oJhUSTcnWyObyD+Quv1Lfb7iqUhetHXolJnjOxMC3l
	imd7OOjgzrfyXKcU+t3OdmQ+GJaCOZI7tLwgmHguEvn93HRAaB3clQp2g4fBeIuG1A1zJo
	bC+1Yc0cow1rMQRfjSubx/sM9aNT3Tg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p04CC6JP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19DAE6013B;
	Mon, 27 Apr 2026 08:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EDEC19425;
	Mon, 27 Apr 2026 08:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777277850;
	bh=rPd+KhIlteN2zT/mdxGUl0xxQxFFeh+yuhfCifYFGBA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p04CC6JP/xzSEC3zOdL0EwDYEmgMw363TeSzjnWd/o9XfThzdwj4KRD8KtGUh+faW
	 x/nDX+q2btk0TblUtBmJfVM3ZIg8LvbPSoT6D/QK5ybN0V45eYDYpqLOS/S2LA3eSo
	 bK41Vwe9wC9pMYB0UjGSrTMbx5xTlJcqkM4PnUBoVjJ5D92EUiFVq1ak7fqr9ZOh8a
	 ijRyI97++oVuZm5txlTw5muFX6dUiawdBhDdT/Ja/B4yIG0Ysa00j+AeNzC6BzkmzW
	 nKUZ/w/HXqfzwFn6gK4m0r3/TCtKohx9B5BT6EuNjzRlyhcHTR+lQObLiModFNL7IF
	 emDAOmXEWw8uA==
Message-ID: <7afd4504-1d2e-429f-ae6e-136414a9d4b8@kernel.org>
Date: Mon, 27 Apr 2026 10:17:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/hugetlb: fix resv_map memory leak in __mmap_region
 error path
To: Muchun Song <muchun.song@linux.dev>,
 Mingyu Wang <25181214217@stu.xidian.edu.cn>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, vbabka@kernel.org,
 jannh@google.com, pfalcato@suse.de, osalvador@suse.de
References: <20260425070700.562229-1-25181214217@stu.xidian.edu.cn>
 <BCFCF1D6-8F39-4E60-AD86-0ECF799FFD9D@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <BCFCF1D6-8F39-4E60-AD86-0ECF799FFD9D@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B2D3120006
X-Rspamd-Server: rspam04
X-Stat-Signature: ork8wzjc5uun91fesq7qn8t7tacos8td
X-HE-Tag: 1777277851-179535
X-HE-Meta: U2FsdGVkX18UjKUxRMT+dboDq0wvDdYQA2so2PFTE52oqhThCM8++R3PoiUeywDQ20oMMjMWPPLxJaJ0mo5TOoa4Syu+HFf5iEAfGQkYVmDaR+T3W+sS2UoMjScuMzL0CbJRf3wEGOpg4nAUa6QMSlo15txMZs2yWiJoG269+3rHQ3Vdhc4zI+4doO/WI4DaW7Ycyq3LH/86t6Z8rHNocVdznFGm4fTcwIKT5yUJigUpk4PgO3hGlv47xsSel1zA2dDGV2wP+x7k/Sobcgow4RD/WnC+57aCnqarlX96KFDzc5ZRw3l+ZWg4WGvtMPYwa3goAMXvHQ99VyjsYHDtCDPCT5FhHMxZX5NESdyWDfICLLSqaTYHuHTj/Mrb2MyebAHCxW6YhlfzHRcs461407/xtwHZv0k/O726xA3CSCg/oC7+C5ieSgO3j/jQUzk4uXqJxUuyJB9XsfaXfFyRSOPqBdTsHsgrj5LCKvgRKp3mn4q2iJCgNqWyC77VZ2ApQNeU4FyJ4JvmQheN5Nv+uGK/RTGtx96IY72eWHEaRZB+wplBR2OxY/m8YlNxMrt7HtFtDKky3mC/JJkLbS+M275pu0KI8a2+FeYbyS+VqQNEISFmwEJFcQkSTZx6+lK8AT/DrpYHqb4CA+lm2RZKnwlgPBteu2YWOX1+7Vo4Mjp2O8ok9B9Wr1GGQCXa8XuFHeJMeTiB3MITAzmRuQCfEzN2ZzXGiw6c6HZp+3gk4d3bakIrXe+Yp3PIhFl/XYZnkYmDsXmEzBuGuAubCUDMe5BclZnXAwekiv/5fnRABBer7EHYWDJp+vkapdZTyTV7txoP6Phrkw1d3x1OzDsQC8V7+cqct4tf24F56Yj32f7vg2P9uaWP7FkK536yTluSNAQFLQPfY/jG3FyjqwNLBJd3vsq/BB/ScB6+Xr2KPgnaueuiBojW3heG9ns0l5ZiI5wVuNe1ICxsp+vBUK7
 SwItDAjI
 AdtyvsaxLWc5sXrEkwvfuifw0pJum/DYcmaFaZKAL5JcfLnDIQiVUi48nYNDo6WK4dAWYCFmVEN2iI5ANBwq+6bX6Y7WDXECWykJ8J6PjE1Y/5ikpUs2jY4xLicLPonQcl1a+bwvHC1CkGKkqnyaDItfeYihrytWyNu2JJZ2RJ2LCvUTo2vdMV/C2bUthH+Vdr3+XeCV4cY+0ATWCo/FB6ClkSP51KeRA8Rok4J8HoZX4xIQoC6Y/Q4RX7ZLYDK32aOMU9w9C9W2L/J/0Xk2cYbgviq7QYHgF1phQzEhN/jvIEWYKcq3QX5IqXXZ7Bp5LOSSWclF9PLnHimpbrpvviiq7TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> 	/*
>> 	 * We cannot permit the rmap finding this VMA in the time
>> 	 * between the VMA being inserted into the VMA tree and the
>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>> index a308e2c23b82..9320f6699fa9 100644
>> --- a/include/linux/mm_types.h
>> +++ b/include/linux/mm_types.h
>> @@ -861,6 +861,8 @@ struct mmap_action {
>> * it is not valid to clear the error here.
>> */
>> 	int (*error_hook)(int err);
>> + 
>> + 	void (*abort_hook)(struct vm_area_desc *desc);
> 
> At least for me, it is not good name to distinguish it from error_hook.
> abort_mmap_prepare? I am not sure if it is a good solution, Cc other
> MM maintainers as well.
>

I'm sure Lorenzo will provide feedback here :)

-- 
Cheers,

David

