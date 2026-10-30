Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394FD606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QDZrOJlv
Received: by kanga.kvack.org (Postfix)
	id E06A76B05B6; Thu, 29 Oct 2026 20:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8906B05B7; Thu, 29 Oct 2026 20:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA98D6B05B8; Thu, 29 Oct 2026 20:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1B296B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:28:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F3E0A810F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:28:06 +0000 (UTC)
X-FDA: 85377405372.17.4470C84
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id E6A91140004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:28:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QDZrOJlv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793320084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ux1Gd4wJ4i6CbO5kAuUr+fRClS71fFbOF44xw5i7O6M=;
	b=5Olk48Cu7TlUcdvFDb/L8qaCexvpBui0Bcv7ODPCxbQbfTNc1Qs8rQb4t+f164Ts563GQP
	uICl71JrnTBtAjf8aBS1xcXafwmafsHUrHmKnA0VIgkZKSIFby5E68FQuRXSlUZEzICAVb
	j/YDjGhngzUyjMkZ/ore+1X9t/Xt6ME=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QDZrOJlv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793320084;
	b=QhFdZaYyUtfaFQLjB8CLm8AMJjOVFb4kXOZbj6BLE9wYd4IyTWQhNcV2kVpw2lZjcBCVkl
	zunffFDgi700JUP2aE00ogN5oON/zbckjlBeigjugGn2zHXRecbj//8XdlkK38uohzdS2M
	ao8r1m6r98//PlZ6VhDyN1ayImYJdhk=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-369f3e9e431so126172eec.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793320084; x=1793924884; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ux1Gd4wJ4i6CbO5kAuUr+fRClS71fFbOF44xw5i7O6M=;
        b=QDZrOJlvIFKVW3lXTen/dxaHO8lyX3L82/FLjNico147Q1Wv7ZTJ7STBRKQJCsA1JK
         tp37HC34FQ1Xy+yAGhtrr2GuOBBihhsp9/qPtec1YG4q6AJ43Xv3AuHTUL0EICULvV/M
         Lqp0/t6V2HMPYUdr1QcRpQQyDL+In3Whbpk4oeEn/ljVdvkZUMm/mGR4ZPNMWpCCbroE
         AmWSTJqVE8OOQJYirZ+2mHtf2CZMHOrluNsDKTRq6Q1MbDYL6lva777xrtdjtA2QxOhS
         UPK5QBFiDF9Wprp/ElHu58BfXp2pvhB2jQ0Q0yygRbgNtpRJds1DcoPKIwWE64/qVqPt
         t6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793320084; x=1793924884;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ux1Gd4wJ4i6CbO5kAuUr+fRClS71fFbOF44xw5i7O6M=;
        b=LMpUeALn/3Ao/XMfbYn4bRswFltZzu9I1wQvytFR0GDj2VhbyEZ9BQlhJAOziaT8mM
         hoI+Ehb+FxLp2pMp4sODpEJpIA8qD7dAFpMgyh+VWEk2vnU5RUr9ViVB0OeVWHPJjdx/
         qpClHDENqd/UTxbeeF/o+yCo24wHV/yrVV4ZhVa6L7Zb67LD9kC/LazLWoU2keWYJ4d/
         rXjNQSayhqQwpmZRyrhJEUJDHAdF0wfvyYQMIRbF8Rm0t/TUM63Chni6t1B0Ho3j4Cyt
         WW5LEM3nj9s5L7W7lBYsbxCF9wkIx7+WYc8+6K7AuLQZ1vCEGVXt6JRdP6G9k+QMQhAt
         DY+g==
X-Forwarded-Encrypted: i=1; AKwUvBy7fO4MeFFuwKztmchEYCYDqYd4LVkO32hbbN25uC6AR6Fk5aWqDEp27snSDPfGrG5eOmNytnCLIw==@kvack.org
X-Gm-Message-State: AFq9FYIbYfuxlpVVEFUhaJCO1zZov1HK9YC8BJuaKicZQwx+kgCXDt90
	jmRw4le+w3Lm2RtU2HZmpcFsxKvGQfLmyehVn3nZEg4YNNcQmODH3bQG
X-Gm-Gg: AYBFou0edOKekpV48x++iF65V/IKVRPG7dj48XhUbqwM+CXOhdQKMXOff2gQFWucefU
	Js0KPd03u1YOHppew6Rdmyir/CEeBaI7jxazMMu4uRjuJaXxmeNfmKBLLoPOr2myDiEz0YQphsX
	wy/S9NT2J8WUqRzPcPQXQwDkxm7rexCBm15MlXjbM+t/N9M+bIOEApszBRuGFe5ycL+2ZKeYV4M
	dj85s41hv1mQ9xLV8H2EDpeow5J76jNzgIAPVPdcT1YP4q4Hjcx3oAGT5intehLs5b3V2RV/Gy0
	UgGsgrjjCAW94pA5ZwdfkyJJUiB7yj8RlW6DXnIZnUThxOjCDzUhK6PkSGUWJanFgFKagElW5ES
	2ixVe/XQNaR7FNFDfSB2tJkiuhe7wfWGqBe1HKqpaZuu2y0+RXmpfeRVvZ+I40qWcRMEjVs8UPS
	mWNg7YK5dqnSGO4X8SJ4EYVU9HdvPWFdP2Qbt09pgLsspZ+2BuxsDRFpyfzUd7ZvUVjj4U6qiB2
	q7bHeNp+1LUcUl3LuH11Nxyi/n+aPsOMOYHiksjTyM35fIwBX8hCcwT6iG4BhZ9ECyHYgSv5Uag
	eVkMi3B3I3vCiKBq4qAY0akMR0NiaqsiUEv+cKrOio83UiL3
X-Received: by 2002:a05:7300:d20f:b0:353:5d7a:cabe with SMTP id 5a478bee46e88-36a3002ea6amr5283586eec.13.1793320083521;
        Thu, 29 Oct 2026 17:28:03 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af1easm1883940eec.5.2026.10.29.17.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 17:28:02 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>, Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Shrikanth Hegde <sshegde@linux.ibm.com>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH 2/4] powerpc/mm: map shared vmemmap tail pages as read-only
In-Reply-To: <20261019090830.1917657-3-songmuchun@bytedance.com>
Date: Fri, 30 Oct 2026 05:56:16 +0530
Message-ID: <fqxovxsn.ritesh.list@gmail.com>
References: <20261019090830.1917657-1-songmuchun@bytedance.com> <20261019090830.1917657-3-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: E6A91140004
X-Stat-Signature: pm17d71nj5dh5isnt5tdr88ioqkinnsr
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793320084-632292
X-HE-Meta: U2FsdGVkX1+RvcrePmN0RfUis+eVUHZw9mJewjBiWdDchuAICoy5fHdRcWuNVWBk2Og6MEzEbUY1RkEHhiN+FDrisNcrsx5KjwylA2sqCKtUQP5371Ru2wNchQNjFs1G3gKPaJg/zDGHRRoAVt91sN+i4TP+g6dkKUolOJ0YelSG5W8f8D/qFL8vRngj7bPKE4KPRbNOhbAIwBat/KkLNjX+jBUAg6+S7gKP9mBLq19Jr4qmbtYjg2cKh+55FBDFG3jLw0RIlabDcx6j2lgAiV1xI9u1GZyJGaQWMnWEUk7GLlBA23/ILvtwE7KyPOv6EW3aqMZkKXTLN0nKPqEMfrQtSWy7iyQdd3YBwNA25PJ2S2Oa9ZSoUkCNiz91xUPLETyN+6Ou+K+pPGvZfvJ13q07Fw6dyLitKgwXHKLTWCvDDexcOCFjw6eDNcqrwC09CTe+eytRKa15aVIsS6h+xDxj5F5pY3hRYANPIhygbXKv34xKscKifztBWmJa0scEXC1JdUb3eOj7JM9gJNbTI8l8Tm/tbJwl2TkQ3IfGiE4zJxWI98lfazaSPwK84TXQbq5oDIOBUJvhRwcP41NoA7PefTygRYVlVngI6s5yauMKFQ9G0t+r9flx1w555Ft4YX5XnbvhziiL9ptnVoKUpuwjoUJIlascF4RAMLNBav8BrPaox19xjceMBdJASFoCWPD8hksU4FRidKxgQq7X5adeXrS0l9lrxvrHm4Wh4Owvb0LSXzJnOjVSwnAEcWDGlT0B91nV6UUPeqHekjJJrZP8I1MbHstkQgpWJYp4A8uP2x8ZPjnuDdrrlMrAManXH/O3P53ymuY/8B+t1jiLCgV6FLWGxsH8RI1jqrTZu67rJD2w9JnPua8YdOy8CKFgsvYwriVonaHQDmy8Z0LawogwK5ZeU4OsbduBGPqxFX8r0cthUPxxi8Y+CUIiFnQ9lM+/MgsqPQtStclYhcy
 kFXMoo0+
 FAshlL5SvOdQxpMcoyMN1je6sb808jDspDdYrvHRNBXDxAga6gBMhaLQeKD39MiqnIh5ICquwpVc2jILMSd5eqgb9682dU1fYP9gujEin0FoLoDmmlKhGG16WpAKSWe9Q8CPXwqI36NLOYZqQO3gG7P1Nzm9DN3RxKg0RHbOtBWahaCyOM97iW4zjBGBjKiBC4ju0fgIfL5j7MvoYvf4Y+CtT6xQ6gTC/5++kRLwgh25skOoDdVx+n1wOaPF5FhetNLUN/lvhuZHvX4Hp4z9wVtMbGr8YVGtsYETWqmB0XmeXQGPm6X5ug37zPRwO/k6GigoLy8CwG6stb0xAQrD20dU9v5nsz24AbTYwVcwgwSzUx8UqIkZZkM8meKnzgqbtJ4Djkg+BgH2aBJCIQDU+qnCQRUb8de+MbMSgoQXNxgNqq8/Q+S++/BGUoQ1jQoHqZa8dH3hYyq7kwJe1WLf91WIGS8Ea6fEqVL/7GiVOaN4O0Ef8OsoJaGT2OxFQYWEpBfQj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Muchun Song <songmuchun@bytedance.com> writes:

> PowerPC radix uses an architecture-specific vmemmap population path for
> shared tail mappings, so it does not inherit the read-only protection added
> to the common path.
>
> Protect these mappings as well so illegal writes fault instead of
> corrupting metadata shared by multiple tail pages.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  arch/powerpc/mm/book3s64/radix_pgtable.c | 3 +++
>  1 file changed, 3 insertions(+)

Looks good to me. Thanks for taking care of powerpc path as well.
Feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


