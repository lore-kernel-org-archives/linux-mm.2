Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29BD7606A331
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 12:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S2QvGZLM
Received: by kanga.kvack.org (Postfix)
	id 3C0D36B05B3; Sat, 31 Oct 2026 08:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371B66B05B4; Sat, 31 Oct 2026 08:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261D66B05B5; Sat, 31 Oct 2026 08:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF3686B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:44:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72933808F3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:44:13 +0000 (UTC)
X-FDA: 85382889186.20.9D2EE1E
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7BDE480005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:44:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S2QvGZLM;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793450651;
	b=N/GEqaDJvwm1fTkbN8kw5TMEgWhBHYn5T+2R1kirrL057KVVNr4N+JUr1Qjkrl4MaSXHUj
	WlAV9YCo3FZ+FE9c9S8jq8b0YKmaXxKiSXEfC3O+wiuuFX+ypG3H4Xe6x/onsPEkJRph5E
	3bWF6CAtF9XYp5W37vhguXZ1CysX/X8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S2QvGZLM;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793450651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qM0g5QCvuJGUtjqSB25y9Tm1UtAHR4vqLa/CLEokVL4=;
	b=0MFJv25dWi9pgOp6mIQb/WW1VrofSLmYKuwemNgAFLvJxTSgyx7MwALS673NsTSFSdyKHQ
	vtk2mUG68ivyl8GzoH7yDoRNg5T6ciU17LwjnzYG8hjtGJ1Grb0I1pTjGJ3qH6vQikXmQw
	l8zRw8giC0zhgO3qKDDimU0PmTwnLFo=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso13884285e9.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793450650; x=1794055450; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qM0g5QCvuJGUtjqSB25y9Tm1UtAHR4vqLa/CLEokVL4=;
        b=S2QvGZLMPdTDBne045PMw+IstjSTOiudYxTh12x0YhgcrarZXNwIsb0lG5uO6gfBAF
         uPq9m79hB4PoFEfTiFUifnEZLBjb1RtDXLS95WyBgyIWVr+ku/yofaZ78Ude1j0yawH8
         VqG10HjwEmRtk0/ZGVTcdlle2TvXCU3X8OpyPvtX3UqWN16zphcjmA/nUYQQaUkXJxE/
         vhipZrFYypfCnnhEIrxr6/lPXyl3bb/FJ4IglXG+eBi+OpODKRQa5eUzvlrj2t8Ozv6d
         GDaBv6z11ZAeBTexxu/gUL6s7IYhziAsoLdr5LHI9fOyxFyVD0Hx57mHJsgAaA7dTk1/
         ZF9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793450650; x=1794055450;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qM0g5QCvuJGUtjqSB25y9Tm1UtAHR4vqLa/CLEokVL4=;
        b=vHAOCstv6QeFAgUvGAzX7AFYwNF4cjdBm9cNG4SJLDLYx1do24DUnQ+W3kgpFrKlO3
         fsX8M6/hOo9tJBC/CF7pSHw8E5/sUH/8v+RTa3kWTsdcinb4c8c54+n3bjd0skmiSsi4
         uWsAEdjNvMVmYt4ZJfzamjmWECVlq6S3IT3cto/F8vWVrrGbDUbsRS7Lvk32PObFr2pN
         ObO/B3HfOot0S9gW593DHjg9fqkzOuACOdeBXkhwPdVhmkAbWhQXWhJ0sz7m+70Ah6hg
         056k/Q0DlFH9JIuCVsa5sELxJbMt1UdJVJzrccuiGQUv+BMsEysm+xEVjSyxhkMA9l52
         loWg==
X-Forwarded-Encrypted: i=1; AKwUvByWUQKABlFAt1usa/gD5es0iRPeFMKpzp5v3faxNUTWu9dds4yo72Zve63cucy/M1GFZ2IBTsXtPw==@kvack.org
X-Gm-Message-State: AFq9FYIDOPP/Kmeb73Lm9UnO73lghoStoTPqeYV56/2dpQBfdFueinhL
	jGwzyZNpjbRWKZUm1IV5xIxrItk54veGDYA6IKLaLuSVZF5+3zMWItyX
X-Gm-Gg: AYBFou0ZFoYZLRcNGQMUd/M3Ja1H+eE2pLr7Fzx8ym6ySz53UNTsQmRkJC3pk1mYwwB
	ArqUcDL3NfdpeOF2jJgGvRtKeHwI2EH0XmU7HoBako0WketDhEcu6ivSm23NLujpM4qYXKhsiqC
	/i5jFxCW+qWfHRpKdL/+sTz2ub51nvk3EvC23JxJm5mb2o9CdmhBJYpLFxQQgNBYbipf7dI0bkS
	Jdl6SjNgL01hgz5ndyFEfSafAvg36YzbwVl/BUQtivFIkYGQSblAEtz9x7PT05zX66ynq96cVHv
	q88uhCq3M1BA08V8q75F3HTNEzD5/WfSqscuzYBNZNJraVwVDdoUot+D/6++kbYGahepduAu7by
	b8M8qfb2fNnCssqJVnHo++OtXo1H/VvyLMqZr9sLaNmMZFUtyxOtDwELZv3ymeu3+yn4ZruEi3N
	LOYjB7LrjymyZba28lr4JLMoHJ+JlXDsqS/ONXxVG4WHK/rA+yYOT5sxn4YOGphrjhls+lh5KT3
	YdoLnAVMamCVHho3d93ECtN5EcihThbKGjvPFbkwhluVV9OchS1hoYa+4TmuIkBZhv80XStnhgl
	pbCIksW4r9WdgkS2G7s7FSPV
X-Received: by 2002:a05:600c:8b0a:b0:4a1:742e:3 with SMTP id 5b1f17b1804b1-4ac185bc4a1mr118043085e9.27.1793450649910;
        Sat, 31 Oct 2026 05:44:09 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf6c76507sm134704015e9.10.2026.10.31.05.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2026 05:44:09 -0700 (PDT)
Message-ID: <bb5eee33-fbdf-4382-83fb-4a8db33ce358@gmail.com>
Date: Sat, 31 Oct 2026 13:44:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: add a uffd test for re-registering
 during UFFDIO_COPY
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>
References: <20261029221129.89068-1-azpijr@gmail.com>
 <20261029221129.89068-3-azpijr@gmail.com> <auW2RZNy4jgR-ZNU@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <auW2RZNy4jgR-ZNU@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BDE480005
X-Stat-Signature: pxr7mrjpqbs5hj6365kt93gasgbxc8o3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793450651-910620
X-HE-Meta: U2FsdGVkX19CMdoyNIrUjanXcN7L6bC59lQ0sNmgqSCtPtOJu0H7wibGF5kK0mTBCqcguaxblFPf3sC7JirRZojGDs7im6Wy0Z156GE7yRvFLI66/YBsSM+xE/XrLxEpCttN395q1w5MCZgtkUjFOcprOtBgp4wVTaZe9ogyxFxOJbEoVVtTirCwyF65PfXvZXo9gDJYI37g4/wYdCEgtHo0zKZWGuqDf5fdcGBupeyRbybSsZIBslITd+j7fFxOdHhJxBOH/c+bRa/PGZpUtzIoyYOEMKTgcZSCEmrgOqoJVl50TwOQMVUNAoqnGKggNzvxf47CdttpEYAtHVQlndRX62kVId/mbNMNjgTRUio7Wgc0t+BF4QMZXHBBmqobRV6/jDeU1JnsUJKjcWil+HLmecG+ngxulbmOKGEhz5UIGeFV9zg5otAv9H/xtM5acHraXiUikevpwqZCo/1rum0IVr+Ub1/VHO5qvOC8MSnceALt8Cl+bQtdLT4F5JFb3O0AXJgvaRScNjRjx5nBYb9PU0bt6Aaz7v7flEOBkRLRovHPTdQ7bQ9KI/2H/Dn9XRJFda7WVHeJszy0SCQwff1qrwjhM/RLtYt+TLLuJJT2OBGx4hQtb0j3a8EaLF4Noz3Wca4XiH7SM5NciUQsgDRVBAP0gJhmgppFD6k5F+1nmqqK4BkVKK9s/wYTfwXJkLnW4GyNcgpSoz6TNnXMYD0TyGzn+InvinT1TFrJ/ZzkiSYx8gqrR0tjzNXjgF7atqhlm8d/JbQT/4GNOZVs46FVcrxb5grftdOfKVqGw3alHS+diwNqKO+uBYaOiDdiFIfNqPkktavvA6l/PuU/iOyZ3XJnX5qbLMCHjuz/20jDCvUvxGGpjXV4+VwneUaS3wzmZ/bCirwm+L56jr8VQoe1qHynbllSQ5C0K82l/QXIuKUkANHKMP08IsW9KTxduK0J3QjphA83dIrVxMT
 mmHn1N74
 gucxOQzHJcBWS79+v1e0FCL6ZykRwYMBzcaiqwCD5+Q7HDgexuJxb7twhM1Pj/w0EQ4UdLpix/r5htPGheF3F6/MWs9EnbTqTfkRWmbVYEZKOwcB+7eSDtyc+NZynBVIvaekQxSto93uu+8LDU1iAmcW1Vu2qEsO9hYfCOCXZjBMrQXMBx5E8I6W/0VQzFmNFVAIjj/1xcOFcE++nRT35b38cbJPy+OD6MwJ/qsiXJzHJlkzq0631Le5+w1k4LQIo0lg3WznTt98l4WPgpmiObuvxbvL0Cl8xHn/6Ukb1r7eNCC9l/fyd7/zT96cuvt7saVWD00Lvoq31n2K8NNoCBO8Xo7mrjgDLbvxUSZ+wdf4EFTKH7Ld4cEUsknexEMIetLp3RGAIQaRQFcuJPrSNLjUfaEqhWG81VLWd9GSg4wQGVwNS9CDqVlw3Ty1OJBjdgDPi5ucuh8UF5XHjJmuElQOtYI8jOPfzyw7QcT0Ojep4cjYYni9HGWzM8JWlSsRj0eNV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 10:35 AM, Mike Rapoport wrote:
> On Thu, Oct 29, 2026 at 11:11:02PM +0100, Jose A. Perez de Azpillaga wrote:
>> Re-register the destination without WP while a UFFDIO_COPY_MODE_WP copy
>> waits for its source page, then check that the copy fails with -EINVAL
>> and leaves no uffd-wp bit behind. This covers both the hugetlb and the
>> non-hugetlb UFFDIO_COPY retry.
> 
> maybe "all memory types"?

yep, that reads better.

> 
>> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> ---
>>  tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
>>  1 file changed, 105 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
>> index 2a97ba1d6feb..8a7efaa7b3ac 100644
>> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
>> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
>> @@ -375,6 +375,104 @@ static void uffd_wp_unpopulated_test(uffd_global_test_opts_t *gopts, uffd_test_a
>>  	uffd_test_pass();
>>  }
>>  
>> +struct wp_copy_args {
>> +	uffd_global_test_opts_t *gopts;
>> +	char *src;
>> +	__s64 copy;
> 
> maybe result?

sure, will rename it in v2.

-- 
cheers,
jose a. p-a

