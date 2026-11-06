Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B08606A338
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZUmkJI19
Received: by kanga.kvack.org (Postfix)
	id EF3426B05BB; Fri,  6 Nov 2026 05:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA49A6B05BC; Fri,  6 Nov 2026 05:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D950E6B05BD; Fri,  6 Nov 2026 05:49:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2D1B6B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:49:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1521FC0D1E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:49:27 +0000 (UTC)
X-FDA: 85404372774.20.D24DD8D
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3249A20002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:49:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZUmkJI19;
	spf=pass (imf03.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793962165;
	b=qJLxy9WoRnAxFtCdpzPZpDSfajdm4ujaa0FjVXCe8Y59xllxZ568RIj6nwvFZ02yeS8WAF
	r4FPCAJ2rPZmmcN7SpkjSgCtBqn4kBWM6AF6WpYO5KKmBVQmcpzbGlER0f6z9qSdgUJ9Us
	sY7+3ftg9fzWWU10zklyp58Ur33+Kh8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZUmkJI19;
	spf=pass (imf03.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793962165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n21l4rAHkH6encd8aStoBcV6YaH3+037KdgWxZqVYd4=;
	b=57+aaZIV72d1vAWsI28i21PdvHP7S2FO01bhBmXQJvxPPlO3p8jUqAdwaouwKohC1Iy6gk
	PwyOEZ2Pzpoj7+BJw3FgqIvb7WfexaChE+XYfWuLzsenr1jHaBP1vH9rDtZI4K+W3lADb5
	pegl1DmzcSRY4C+30gA9hzZpSy1YU1o=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a208d93758so4916445e9.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 02:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793962164; x=1794566964; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n21l4rAHkH6encd8aStoBcV6YaH3+037KdgWxZqVYd4=;
        b=ZUmkJI193rpgXf5ALoaXGbpK6wc3TpWqak7sUQRgqgEfhwpI49j9xTB8wrdDiN176M
         SUfsqmcdKrRbVApdhZf+r9Bw295hhWKK8F8FkdZktHQ0XVrp0BbsHsGdCQ5tjmOldTpf
         aIvLhlI+7KGYxs3GT495sIF+n8jqwfvIIH5pUH1u0YE3eHMQ3Xgy8fc/qNp8sU3neCuj
         XqAqM/MUrzhFUuiR0+E7Fn7+JLul1lxQshbEd0sWDG1seda4qLsjX2JsHahiGZpHaYDb
         ES6bEbTnY7WXXaDa7MJrntwQfIctqqoZbLcev3SCdqisEm3nWYXwGK333+OlUy4oAyug
         WScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793962164; x=1794566964;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n21l4rAHkH6encd8aStoBcV6YaH3+037KdgWxZqVYd4=;
        b=U/5UT7Sg02gLxGK7pXEK09Efa0SGnx+rJcGR/v+2Ir+2plDUSMQOxHANBJpDKVdwOV
         8+iOSuyf2om5dhdGnl9h3H9iUZbX4jUU1l57zFIq2IgltM3GxAGjueqAZ72CpQJGFUQs
         hSZOdbw9j4WrPHILiJ9K7AFi3bZ/75Zpi4cq5CooX9bPRT3kgdFw8tpVqGAxxLioK4RM
         SVTzfnC6oz3mVyVHHW9NeONLHo2IkhQECPYJh1AWhVvvhfRybQ9F2NnfgNEQuOoPMlX9
         mNDvKjT/I/y9mrhRf9CycXC4Bw5/dTYR/172qyWfprWShNipFBA9/4OnGryuOQ+gjMbH
         ekcA==
X-Forwarded-Encrypted: i=1; AKwUvBxFA2z+LfhsGE39QJuXldvlTCDx52COoJ+MB4faJFeoVb+2NTKWj6c7QUeC/3tzoBiY/dMNixxOpA==@kvack.org
X-Gm-Message-State: APuU4Z83wQtiuphWlwlTnp/rrEeNgeXTmWOI2C4RQr6Bx+LMxE3bsdkd
	P6yD36FiXZwa7PaHFG9SfkeRlbZztXzkyPH9GoQ7Jm2OhqMmPC1jwjC7
X-Gm-Gg: AYBFou0nkZ3yreFeCZVTZr2/xUmmYr+9J0l3TDVf7SexxEMQt4C4xvJOuBGj+0TsaJD
	6m4BEq326FvjvwkoqUZnousAUsSB4LFkwbN+sxo4mkDgIW4+CUcqyh3Q8v8xficAhYjFqh58uMe
	D/cbVD67tukJHIq3x9JatG3vjCrDiLYeF2oAD+uJNGuFbfC+LFwykg3zcPNmKhUXwxc+k8I7jqk
	o+VulRovWGWluzJeetWQX+IYxboxrfMcvU15BMdcYTUEV/cWUD7Xvl1jeobdpHbTZsGi9zl6q2z
	V0M73+30YZwRAAXUhQNjzDeFwf8eQVJhOSinsDXdX2Q59Z4f5zK6ZHOcLlxaz1ags0eLmlKOyXG
	H5GohYnNkJvNfdHK8QgzZPhkLDICKoNvP35PPqoyKlA3C77KBAtPqyklhZ9F8rPAR/HtfJpqO1K
	gOd6seW6Luh4MMFRq5oQFi8KPtb96B+M3EHtu7ZqdfanVIEFqYtDeb4n+9puoLppnC3H74XrUOC
	4icZREZMl78nkG6mc+wvuSai64AH88vdxigrwQAKb1RmU2h7FCtQvpJ+UnCVE1fpTE6cRKauNno
	bg3AMeghz7Y147+wxnQc/sM=
X-Received: by 2002:a05:600c:5295:b0:4a3:59c9:a756 with SMTP id 5b1f17b1804b1-4b6de973c5fmr32952175e9.6.1793962163759;
        Fri, 06 Nov 2026 02:49:23 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b6e24012c3sm46488775e9.13.2026.11.06.02.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 02:49:22 -0800 (PST)
Message-ID: <1188802c-3661-441d-85a7-3ac68042e022@gmail.com>
Date: Fri, 6 Nov 2026 11:49:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <551892bd-d7ca-4c79-9c7b-9d3d08c913e4@gmail.com> <au2lAPUNPlRtaeFY@gremlin>
 <5c084ac1-930d-40c7-b6d0-b56673da9cf5@gmail.com> <au2sZrlidH_f39kL@gremlin>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <au2sZrlidH_f39kL@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cbma4ps3qghqdee98yja53xrwsmpi5bi
X-Rspamd-Queue-Id: 3249A20002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793962165-208064
X-HE-Meta: U2FsdGVkX19PkvN6eq0ECZ9420AzL77dwwrrMxFvLKiPyVpo31cn3zC7ChY4FbHJUhB+vYX5SdFXU5TUJkI8eos8JLSF00qHO4jqsLaNFYhx6Ta0z97adnHbCFBBuWyWucljfvmG9WNRz10DBrH3lgQCvKQGG30bbbjx/HcZL4y+dIe0V+crJRXK+ZiY8px7F/Gf9dTJZt9ol80DaBPHNvuEf504zpcrojnS4ifO3K0lOgnPLIkOqywtUjg/ggAzUIlbHtkyzpLoSKzIDKPLC6CLhK2AFL+wo9isT+j2lQXMSVdnnt+H2+ZowuaNCclfwSEqxeuOujAKt8i7uwH5R78K0wIbUCsIndSOeK3rxUk3O+CKnYEFWgsH6QbBtt9aCa12EmDniTkQF5HhozXttDCdeX8F93P3ju3eeDVqtrMCSyMdOqLvmzHiT4sxmG5MRw6t6q4dIoAadfvet5AFlPTdp5/HvnNECF8g2xr75Xde5HDB9zTfQlPhnxoEtbEbIyDWyB038XD8a7RTZMUGcCDFpgQa6fit/5nmwpDML3oEPcSOv/A0laG6gimgMhj2+djitjbDLvrpwackvNHhOaVFflIA/I7nYXk8Aj8w1lS0xkOxBUi3U+6iKfbkvgtLg8IwKT2jB3q+pKSciK8igGrgXqwvT7zP9j4Z5vMsZPw/rH39aLEYvHHcZAzKvjVm9gn9W41kf5MsZi1F5zBalYlHi+syDqCxDja02jRp6S9XtAgb4RYrEGnDP9Y2/3+j72gJBWMIjk8AjBLMyoDv5oJE/JHGMeYHUeKLKqSEBpzActasnJCq1yCPnoXLBhQar2hmrj7DKpMAEl7TjTcFVkgwzQMM1gyLsdlZCEepPFvgqi06/vVQqUqtLNdYQ+mV4SlKEKnLGC8TAT6WovWRHUS576cQAVXZWsRoq2zGEn5adk30X+9SoLSEcee4wjt/5VCc71VIJ/nMAUookKL
 PES9+qgR
 PFH1mP+/bvIuQXwlV2BeDLdAJtGOqVnNfWafcWDJQX7/bLEPxCsbS6NGOCfu4dVFZO5z7UcUNUSxzWDiJDwtrjTZ8s7azLT5UNpUfZZ0X1gE/8LPbYoNuhdKBluVBWC7xz4pvUzCdn7grNSrP0JxfEGFzfJLg6UyBbAjlxWE0qxn1kJyvp8uxwnecBqZakd4rSqdv8QZ3EJYgHqKyMFH7SFV/81AMFAjUYx6M6VANrZ8G4qPNjH6+xn/xBHJERlpcX6X2bSf4+54oWWSOLha9oKdG4hkXJFuiRKpvpssyObe02Q5vfGHZxqWzs/Zzo7kuac5SjU/WuXjSRzwqKUp5BmNXUAdQ6CDxzQOg24vpELtvSmFMU2zuevIfweVJbvm9dDypWWEppNi1JmA19LBGYht6jrnR6mCwh2u3soGNdDq5VEYGW5idRpZKJqtm6DQwBIGu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 11:33 AM, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 06, 2026 at 11:29:00AM +0100, Jose A. Perez de Azpillaga wrote:
>>>> with pages_to_scan below 4 the batch is 0, so under constant contention
>>>> we keep dropping the lock at the cursor and never scan anything, don't we?
>>>
>>> This feels like repackaged AI review...
>>>
>>> The mmap lock won't be eternally contended and if it is, with pages_to_scan
>>> under 4, I think that's fine.
>>>
>>> Alternatively could make that >= an == and the post-++ a pre-++ and the 0 will
>>> never be hit in this case.
>>>
>>> Or could have a minimum cap.
>>
>> with >= a minimum cap needs to be 2, since the cursor can stop at hend
>> inside the VMA we just scanned and the walk lands on it again after the
>> drop. with == only batch - 1 VMAs get scanned per cycle, so a batch of 1
>> scans nothing, today's batch-0 loop at pages_to_scan 4..7, and a batch
>> of 2 hits the hend case. it's safe from 3 up.
> 
> Please don't copy/paste LLM responses. I'm sure it's in good faith, but it's not
> helpful. I will run any changes through AI myself.

it wasn't my intention. I am bad at writing reviews, so AI assists me to
reword it, so it's polished, and I still check all the output. now
onward, maybe my reviews get a bit clumsy, and not polished. I will stop
rewording them.

-- 
cheers,
jose a. p-a

