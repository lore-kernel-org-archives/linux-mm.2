Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4413606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tmMOEdfc
Received: by kanga.kvack.org (Postfix)
	id B6C4B6B05CA; Mon, 23 Nov 2026 12:38:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43B66B05CB; Mon, 23 Nov 2026 12:38:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B176B05CC; Mon, 23 Nov 2026 12:38:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 835EE6B05CA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:38:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0F05A866E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:19 +0000 (UTC)
X-FDA: 85467092718.11.8C3E974
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id E23451A0012
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tmMOEdfc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455498;
	b=TDsgprjv5ttoMtpKnfFqVycvrqL7U2BdCV+qDBjby3WQ886+GD8SwqAz5iQxLhnHWLiEVa
	hJiZc/FWDCQal1WlSZaNXWkGGba/p2vAqi11DqwaPA07bGQwBmBmhezIKLD32rZL3L6FRv
	ljr58bxutbOgtjA+DdFoqHuogL1ODjI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1M5yDkdzX/Rb4W+2dS9wDYqcjAMc8nYVaw63tkuJdGA=;
	b=dpHaQmkNu7EGgHux60dL8xeLrwhgMWBYcrmYh9rQRCgmvgi6s5zPEHVapcOOE4B1KfU2Vx
	xGnAKWBpYx1WvjB5Pm94RrMZlf4p9UXejkez8vONG2x/ULwccJ77f4wTZwvVdRtPL7Zw1w
	SL1nI4AiCeiqJIXHxqoVA9DBICtrrgo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tmMOEdfc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-386a9d47d97so223440eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455497; x=1796060297; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1M5yDkdzX/Rb4W+2dS9wDYqcjAMc8nYVaw63tkuJdGA=;
        b=tmMOEdfcF6s1HW88YzWWjyYrQVNMH1Lm+XvaJjR2jjP9NNJzTGRtRv9eKsSSzU7HYI
         FGDlsiu4VUFQrmpC4S+sAUd+YHVD5jmQ75ESeBE5lTuBKoG8h5VsQCEVGTI4OFmaeSVM
         RmvZVA7m/R8m/eiDfSv6QqyfIad+0FSFl2iOPv+k286/Cv0Anjh6tNHwgjJWgvctm/Sa
         tHxS9v9yo2ji5ViIkFxDAuM8WHC8wak5LwcIKCqKsKryLzc/WUAw9wIa4ObscSMGsXj6
         4puH6CqfBzYL6ni+Bs2TYNwJSut4ehaLxfIEyel9gA1JTgq7wTIW+vmLrOzsNLFeq4iS
         lEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455497; x=1796060297;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1M5yDkdzX/Rb4W+2dS9wDYqcjAMc8nYVaw63tkuJdGA=;
        b=MzoP58YNb6VD25ECCn4uYz48Id5S1BO2cDeXG1yjEHc609b7VD8Ns1F0quEEw9fFnq
         OizHoLUHH5WVpqtuTeMkvvtsnZWc4m273FN0//o6tc8xJfvjbTo7APp3PimaWzaFqou0
         zBv3cVROIg07rbAxPPqZzRFdwF7a9VsyCX6zR5UqbKUvEPKzDXdcwQsTjelGEYs9gMjz
         3RjVFcCZ3aPFkI/TyG9zbxLwsL4znH0Rrj8mtGD0Y9abJzwMrtFYQJk7wqKWYOEsmdjv
         TC3L1voQU7+8hSSyNudApCZi38c1GoZZ01roy0XiJUlD+hVQxyUvJ1rSwnqXeKmVnsXq
         B/sQ==
X-Forwarded-Encrypted: i=1; AL+hErGg/A7aA6n8M4VT6BZ17X5MLlywemaZ/CK1ld8Kd9oMiU86VT91ZHKzriaXhclvo/INzsglo5tC0g==@kvack.org
X-Gm-Message-State: APuU4Z+WSL59X2JR52yMFaqP73di89dadYPMdwyB4ACnNYbDeC19p+wA
	u35GlQHatJjZTZeHdHt1PTJBAAvddxy89C2QWDEonTSw0p+vCwg7xeZ4
X-Gm-Gg: AZFdTZeOA2L7Rw3HKDcdJBajvvSNTsT0Mk5PdJwCa83RCIt6X2LBPbPltMawm2tnLWX
	v/Kpgpn5Awu/mWU3/Pr0LVjW4j5BdGZRWlvQ+rG72NclYxZhGLYbQmNJd4J/1HJ+k5GZCZ3RVKD
	tvZNNklATRhQNgqnl96VRZl67ofsJ9IaEkxQTW1qqo0jVYmepUvdZIM981o4OYluOarIkocELBq
	juYHwP6Jut5F8NqOI5w+oAIMMU9AcUUd+k1RDDk5khsoI5eIxGSIubDFd6MW1FNzxeMPsa/l4gY
	ygu+R4f1wlxO7pm+QEM8D4e0h8X2/BmiMQOsy8Fh7mAIgfoA7+wYwJ2sxBXWRsrkv7i29/3206w
	mW2v3ICo7qe47VlPITxjWl0AwBvH/dCNR8CMeOwNf1IzkWsko9wWsRRVBABowrwnbPT+CerHyCL
	Q+QFqrbQMi1eU86ryzBqEMOZHd45Cg+fpH/jY1ru817BBpDtOxkJaOHcVgiWjB5bU5AZ2EX2i40
	NZcvNRpEL8o4MizOyBpcNSHvPYuG7HiFBcI7Z0ozDBEmVSppWQlBgc53pvzJGJ1adt2NtEPr2De
	8dj8gaUchf8VvboqO6g0zCLAt4/1R913bPOFXXeg48Ue8VisMt8oWizlKhZdVKGN+UiMysg/lMR
	HiW4oivrzePZN7RiNmygMbfERpY9vBBiSSX7vu6gZP0vp/+scp+MtRt4QHt6lBQ==
X-Received: by 2002:a05:7300:f483:b0:384:e31e:3c58 with SMTP id 5a478bee46e88-385714160f6mr12146290eec.33.1795455496670;
        Mon, 23 Nov 2026 09:38:16 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:38:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 21/27] mm/damon/sysfs: add user_report support for
 report type input
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256489.4.16849196400062499517.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-22-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-22-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E23451A0012
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: xqf5t4c55ogxi8m643ieazxapyb3ky5w
X-HE-Tag: 1795455497-48824
X-HE-Meta: U2FsdGVkX1+D3YuTA+/5yaB+1HB6c+eEXyiKeQNTDFPGEKiwmMp51DmwK7z0v7IawBV/pv+SDH1CrvOrfCcneXUUBD6jSCV+Bisp9yUS3VcyktMzg6/ykf5Thw3t1i+2jkFJmBM+RiiVeUcQ10CBTOq09ot3zzeOkBGWq49FqvihvTBQ2i7ncV2Fm445da1Yn3cSh/nqcDEr0GZFp7oJNcjBRuyvUzQdfEyYHlvkHQkm4eBSes9WZZkbIROFBBa8dqP3l8q9p9Mp00JWiZnjPzZ+0/3ReJcao8pu5DM/RGN6zBuOO+A+aoXWIIl73zAEVrWoYV7N/junYJ9aQ8AtGbQ6RIFEqlSM05qYXB72nLqRCJNKmNvJLxWEVfKpmsA7FECn66Yqv6X03Oy4hqu8BAPevKCPTjfdNsWWK5JwQQeM0Egkee3RYnt/YRrcqPtep6SWdo2un+MBFBxlhhqUVk1ASQi1OKNmVYaitY0xIko6zix/YUbiizNbCM+jfpHUksRGdzDeFBkmD8Xti/ipthHJB8+Yh0JJ6NSQP5LS1bgQ0H9OG6xVSozqI5D6V4IRkjTVROyrxPxlXHo3DZuyrP67OQYSqPs7eO4UfXC6nYnU5P1q8SjoADv1VPWGxyeHgLiHMGwvGIQ94xO+ILHhgCtjvmLBlwJugKAd88VbW8bgzcjn0lRZgvZtI0y0fCly4rnTzsj/DkM5lXgpXON5bmmPkepMOj7LoYd6kW/1EeqlBJ95b3d/09Ln+Ex9xelONdcUJFyr2Ow22xqDl9OgyL8kUStL89l6NObmsHtTV2qrg7gz2vXQTSO+2jKZRZzrqNAE7Nc380KgCG0CXIpCLo/0G2N3WtbgNXTfv45+EzrKTN/pew1svv7NK0aG+sQGtzOlMitzpRXLDov/62qPDeU0zx58As9867IzRhEcSfTvRPCEYVLa+F7dZtfAr3F0OIC2uNlMLzgVPsQQU/t
 Jh9dC6U6
 wfQ67PoXqCWgt0uapX6/Rd5e9oV3MvcbXXFNS8ZGiSGoOsHq84izugXPJCzzy2i8zDIoXASFrkiVGZBSI4bv0KcRfM4X9wB+hFhQzQ9Y3ZrYYTgRa+XBJSzvq1a822flfgdZCuf0WkFSP3EUcUx/4jCDiLV3VPCkgcN3L8UtTuwyHIF4Pdw7E6gSQs0wiNhXXQzt+zJiNjSRLR/lVUL1+OUVaR9WwkyJcdrWN5dJUfp94ChDZ6ap1xc4WJIlFmE6w96IVdS3g2Qz+NhmUXUb/ZGYPPuqfD+w0u8kWwuhCKQhAF06S5EWE8tv+FjaR/LXzXWpWxZ03lrYmt/9/6722A4PIuGvAKrW85kEXaulhJJEuXPwb9MSf5foFb//VCj3FeM46ibFSJTcf6Gt5rzwFnnGJC7N6bAEfsx5pWdSZ1daw39ou7To6D6AfnaOWxfbKJu0mirjN9I+wP6IurgYpZikGsspnZazHVG2gNIYhohjUxgBtW/ucnaW+5dPtFdpciUMo8+P5sk1ioPSIuwVBe4U08W5t9d4PHBR818ahrgsnfKJlk684PUJGKp+Guv/UlIfrayyykHaJAxRgjlcpF+5BJqgiCU8qrx9OmPjg9U3T9E0C7vRFpiu6Gd7hp3Z6Y8rCaQt57YU17qq14t0tyoWt8bC4xYmgMX95FJT0NASETRdOAqD/d6nIw+6aNan+tN1VfkHIjQuCLat7zEr2xto+Nog8y9cahiuVlL4U+CK0t2y3GBlCgJhk0inQV6YRzcxGZw2TlpIBwKtXYAXjpBuw7JufU7vLzcm02+6kEpj+gTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:05 -0800 SJ Park wrote:

> Extend the mapping list for data attribute report types and user
> keywords, for the USER_REPORT report type.  Use "user_report" as the
> matching user keyword.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

