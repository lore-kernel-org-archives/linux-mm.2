Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FD660727A3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rjeav/qA
Received: by kanga.kvack.org (Postfix)
	id B44BF6B00EF; Tue, 10 Nov 2026 08:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA826B05B5; Tue, 10 Nov 2026 08:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6D36B05B6; Tue, 10 Nov 2026 08:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78B9B6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:25:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10C3FC06B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:25:43 +0000 (UTC)
X-FDA: 85419281766.19.511B383
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 23B22A0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:25:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rjeav/qA";
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794317141;
	b=J8mxsO5M67YrMdFNgdmJG1UiFrfYxM9t8iMxMHbazULqq2XjD6tIGzzsUg8VEf2Y4D2a44
	J7CSr7eVv42Q7RthqSLR7xZSsM63+KqkOJfK7c9OsnxYwJGrdFPe6XaFpqBoyza2h5BzMV
	8AJKp2QE+YMKiLTQkpp0k0MjpjDbEQU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rjeav/qA";
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794317141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60bvnn5EEmm7amBiboedAhK+TLPffs/DuoYwNr6iHtA=;
	b=MHnOP8+DrJ+1jofCmyl85e4ZQybp0SyNfB08Y16mU+OF7JxJoynvEnK8UjpAI5nKpJq3/1
	db40E8CEkRg3wPDhRfOSubc5eHGTnugB69qf2EDj9nctpdEy4psEi2HkTDJSxbwfWS/Wz5
	n0VVhtepTW+HE7eya9SwdD54jxKQ4oE=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so24727695e9.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794317140; x=1794921940; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=60bvnn5EEmm7amBiboedAhK+TLPffs/DuoYwNr6iHtA=;
        b=rjeav/qAz6MjX8DNyx5zlFHnKnJO67Blg9YEr7oY1OfY8h/8vfwjBBBgsn2NVVoH6n
         2ZkfSK0tEbX+gKodE5k0SJuDE6JIQqPWsD2ZI8UC1qC0nqrcx3VGSAF1IAUg3Z5QTF7D
         gmcXNn/Q0KXx62vAkT+DybpY9Uyd+H1Q7qcsAL3aFM+gZrS74dtymnLBL+jgu5w2yLGp
         B8eEv8d82tcOUaekl+3cvxYHH3ktIsF2tYX7hv3T5MiKrUeC4AYRdWFyM71f45FULK1v
         8BOovkpVVaKme42Ex0LFVeDnt9CM6q7RApjjIdBwO4AFAproUPnn6j29N8BhxEWi1vnm
         BfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794317140; x=1794921940;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=60bvnn5EEmm7amBiboedAhK+TLPffs/DuoYwNr6iHtA=;
        b=Pqfxup6pTTIFUOQ0OFsTYIxEiUUImllKC/p/x0jU1F+kWhfjZFeUe81jmScOUPffcw
         Y1jNBoBO80bexdbqbfnvZQAUYqOKQs3Hns35c20MvJuqH8fUNfBW+JNgDvyPM/c2JiLY
         QUjjquBIpcEWRZB+egtllCuNV7qJcjePJy3g3+6kZnMW96KpLamoY2Pi6Hq5XXtxjDve
         wIydkl9GPVbnFLL7jGPhWzkHrxnijFW3P7DWdZETcp4sauIxbAYKvdY6pBSJmYQychDb
         DFse3hnNhWtTTvu/l2EqxmcR8ICByDTibrZwCwEW9Q6PFr6w6DC4A6Wq1wKa4oarJwGu
         +C6g==
X-Forwarded-Encrypted: i=1; AL+hErFxDgzz6FNwe/EIwCRaH6ECrPWj9UYDeWd1ZHMZvHWPUpezJcK7ud05IAXDlS5IJo1rv8EQ2Ej/VA==@kvack.org
X-Gm-Message-State: APuU4Z8n+keAHyX6oeqQXH3Cs14NhV2iCyIXXscJKSsyP7wn1skjcsLC
	P1CcFuoFpa/jkh9n/ZLFSfATmjZy+/vFGl3VyJFoOu6sw+WNRhPv9F03
X-Gm-Gg: AYBFou0tte+B/YZCF29bn1CbCjQvUQM9JLmSeBvbGSN0t4yXS4ZKidH3NOuakIRNuBY
	YS913hAP43iu7fOCvO0dsyE35JeS3e1pVAASMumih7skFzm/8CtqVSHRi4bgDYl6V3ltpHt1hyT
	4URz6dB5F8+fIEGqXpnQJIVmlqGi4IczHnir03BrH8nb5uysGkKRifS0RFLvWKrwzwKxDtQqDWo
	Dfi/hfGy7pZN0FY308QCH/Cu+6HXdr64byUK6hVVgeiFb67x7ERnkSpsXC1a0TjqKXf9h/EnXyQ
	muFz9eMhJL9BP96HNxXwHOt/frXu1qO49dHFTLD9v2ntRTMSWTn2rn70XNYaQ/us4S/oQPkd9uy
	XE0T2uOOudszIoPoq5wGLYjgP+LIk6UllDR+YwWkSbePKgImXbjt7Dysy5ONILbS1UFP6VrGL8P
	5MnFAAL/Rq7caZKfv3BrRVJGQDCPJdi6kmv7FkBoWU+j10LpPhb1tb9KdYozg4JYIwb6wry45In
	SUJVpOnOwxwKsHcWwSDCUDst1f2QZUrhl1ti2qGk4R7Piu/5r/tlQ7zGtwlZ28u4YyiKDQrcVHD
	kE76OAsoPOy8ilOUn7VaiVH9
X-Received: by 2002:a05:600c:1c0c:b0:4a2:150f:1607 with SMTP id 5b1f17b1804b1-4ba0233e877mr48531535e9.13.1794317139210;
        Tue, 10 Nov 2026 05:25:39 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba0203a76esm55864295e9.3.2026.11.10.05.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 05:25:38 -0800 (PST)
Message-ID: <057dc7a4-cdf6-48dd-b326-49c92a936b9b@gmail.com>
Date: Tue, 10 Nov 2026 14:25:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm, vmscan: make kswapd unreserve highatomic
 pageblocks
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, JP Kobryn
 <jp.kobryn@linux.dev>, Frank van der Linden <fvdl@google.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261109-kswapd-highatomic-unreserve-v2-1-6587ca75c77f@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261109-kswapd-highatomic-unreserve-v2-1-6587ca75c77f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 23B22A0003
X-Stat-Signature: uyt4ewfpw3p7z1b6gkae5h6gz4yc6um4
X-Rspam-User: 
X-HE-Tag: 1794317140-785206
X-HE-Meta: U2FsdGVkX19iGHw7hJsGmCIX0ZjuJ2OKLoJe7J4jtE3SJoDT2GH+c1Ji8NvjZ5/DSf2WkKTmzPEwwwIPyg6k8Xn7LBp2G2Dp3WV8fAWJarzimlMfxSPPJqGt6ta/Dq2xsyUJBhX07kLUSdGBMd96e0c7Yn2H892mtaYKnoWdbn44yltctP1wAYERLx0iIbLTOqUkNKmHh1+7mZGxrnVWTQ3O2p5Lypw4471d7b0NFtqMUCrcZL3wY/5HQaa5ZvOCn/jChexQyLsflzbxGVQ7nYizxgOrWE5gTg/07MQ54MXOK6ZNUD75QN9u6JhYj8qy6S6Cfh9egliluUTh0Ly65ASVQbY1ELcY/HBydzzd+oqJcTBqGeB49MYoE1Il4yeYp53KgYRCJak0S2+UDt7MX4tdIwO1mShCHqJ/76Y7A7jM806wY+bNPLj+g+HCUlZYfBgHYXBLW2Idv4Rl4NlLvPmYYPPuoOoZYxy/gEYpOYut6IVK1gyBp7tvAnWrGtTbqE5i4XXzg79jTqbLEWXolezcynpIdekAj4phTRd5Cwn9p0lQoBZbtsm9cibwThBWBVo+DWTOibkXP19H+a1JA/A68pbDiEbxkoku268DX4twwL5iWcBJpeDFqmPJ3O4VFfNCQF3kKUldLRvazXFwoYWTr5WUXIqoNHnm/xUGIrCLyll8290n6nXp2qvwtJxywtdL3IpKjjkRxPYwjsVcjb4NiCDxyGdpwKkos/2oIisc3jmdfc5kFhEjTVsCew5P5aApzeu9yp+BxnyGBUELQyhINiGKaX4yuS5tOCnnffEiFos0oCXPrd6BfAQH3EHBnBVTu8THFmsfnlepxThevcCxyHnbLqXqApQ97fH0cofZYP84q+GXSN1ukU5JingBBMykRu+eembrUVElzkhy48NXKtQb38gFd5ebIcVBoJqTfkUIATQVhLus0vvbj92OQhV8kFylkSHJSQ8kXn4
 nDAaUTqX
 XS9LfohPyRA1HgjGUX17jBCOXG+CVyc3aftceBfE8sHMlnZMB2F+g91FdfSIQLVnPJdcwT9zp1eff6QQQf5IBqbIXWhqdahHn8QU2uCloRayc6Yj/xZ+hLwjcZvQj3cxqd3LiNOPoAWqaVI7Nxz9FwsMUAyCa7Dn13rHZXoQ8P5HrfO6AOCoGFClGxWv/wiDg2KRLRo2bb10F/uKCleCkBKUko8f8ZuIicNFlVdg/72SECdtyuN7JpeVaTAgYovIwz/1oOHvXrpsMYQ9d1uWvuIvoAsNpx7veAtbPs+YkR/c5Rob57CrRWfPREZgsy0L8orYHsQlpeAVxUpG97mPCCAokYoiu4WZs157wHNA3jFxzdr88Ou8y2AvTduUP6Cz3CIScI6iSN4pj+F05RA6VPevb2m46rS/o2R30ywlzqCybQNb8LKoBafox44Okq3br52bL2MiMd8mjsL/mvpodzh9lKPC4fU7KEeUVGTfuoKF2SeDAMuXMyWELSCs6eA35xNlcmLnyY1q0tafyTuUy3wxZnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 11:20 AM, Vlastimil Babka (SUSE) wrote:
[snip]

> Hook this highatomic unreserve to the moment we exit the loop in
> balance_pgdat() due to exhausting reclaim priority, which means pgdat
> was not balanced and the last kswapd_shrink_node() attempt returned
> false or failed to reclaim anything. Even if that last attempt made the
> pgdat balanced, kswapd was struggling enough, so unreserving is far from
> premature. This should be a more conservative variant of when direct
> reclaim failure triggers the unreserving. Pass force as true to make
> sure repeated failures fully unreserve everything. Also make sure we
> don't count kswapd failures until then. Don't restart immediately as
> the kswapd() loop will call balance_pgdat() again if the unreserve does
> not lead to a balanced pgdat.
> 

the lowest priority gating looks good to me.

however, sashiko found some concerns [1].

[1]:
https://sashiko.dev/#/patchset/20261109-kswapd-highatomic-unreserve-v2-1-6587ca75c77f%40kernel.org

-- 
cheers,
jose a. p-a

