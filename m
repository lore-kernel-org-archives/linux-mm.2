Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E2FEE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 10:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A306B0088; Mon, 22 Dec 2025 05:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7BF6B0089; Mon, 22 Dec 2025 05:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4416B008A; Mon, 22 Dec 2025 05:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78C0F6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:57:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8A92160AC9
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:57:07 +0000 (UTC)
X-FDA: 84246804894.22.3365832
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id CA45A1C0004
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:57:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="U/t4Pb06";
	spf=pass (imf20.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766401026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVaLeh7HdWjqionAuyu2RoMDiu82J2XaxH32QozT0Tk=;
	b=QNquBcAlQMRYpjD5nTTnRHVGGEQbYT+Kw9DZHyrz4cOSdGThmpo9yurinfKtwz9tW75Gk5
	W3Xs1Qvkp9YzJc4hyEPu3V0aOCODMJXeCesv4rsdssviWvtzk+bX76riYwjAb7DsI3Gz8i
	ekIhNP0clXW2UHGpRyNuO7IFhvpcFao=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="U/t4Pb06";
	spf=pass (imf20.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766401026; a=rsa-sha256;
	cv=none;
	b=ypplH8eNtknL7VkJmWiieL1ANrevwcorLMtlo9Ro5IyP4YHK2ZX1RPbjJgmhaIAotjy725
	CxckXrd91svZ1l6ywaGW01AY4l4WKTxFiyOPkL032Qa7wS3sDZhe+tUverDxs/SKns5G41
	PpYNZKGQ4N7sRRLWeQ4vWQy3sIQ9B8E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766401025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YVaLeh7HdWjqionAuyu2RoMDiu82J2XaxH32QozT0Tk=;
	b=U/t4Pb066IRgM7wc/eIE8xG2yOVAml0iyAPs6FdYFEYGMRCo/wwGo1CTglWuRLK7YmIFfq
	BU5YQ3xg/jqX+NaX+RbL/yZPZ/Pp2lVkVS+cflLOs6LFzt//ImY/FKsw6x7VsiaQ85yl2c
	Zxk0vlLf1DnSZKyUSZqtgdjtPo2EfeU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-Q6wanQR8NYe2iqQchUxDCA-1; Mon, 22 Dec 2025 05:57:03 -0500
X-MC-Unique: Q6wanQR8NYe2iqQchUxDCA-1
X-Mimecast-MFC-AGG-ID: Q6wanQR8NYe2iqQchUxDCA_1766401022
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b993eb2701bso4073758a12.0
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:57:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766401022; x=1767005822;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVaLeh7HdWjqionAuyu2RoMDiu82J2XaxH32QozT0Tk=;
        b=nL94jUDfKMMtyDfPofZLX033Qnj2OxVAZM/fAS4SK3896XOwVCS2v6Yhp8bQ4jN8wF
         ROHONLLFd4fhkJCYSAaL/q1amJwkXNPOf6lR72zJy0e6zH/Jw418a6z1eEy3W/Rw71t8
         fWBo3F/1LXPLTYV6e97jDNbWawQr/ucN4e7etvbaguYClOwiHwqPIJp3eDN/NpHpQuug
         m/n/RTvExLAV1kSwOAAMwDgtDTXmoCgbfMwL0W/o2JcjIRU3ZO0NFjMT/SU8b09Lzk9b
         77P7J2nTfay0yuLN5uSjTBAHy4vyW6ermKRfwE/DFkunzC2ldR0c58GAuszh1P9FetAK
         +Oiw==
X-Forwarded-Encrypted: i=1; AJvYcCVvNY1fRvf7ePaW4CQYq9ONi2RhVTdXpYeT/TkfXQcIJHiNYkANHw5Bj7m5gKFKu+L7GydX/+8lmg==@kvack.org
X-Gm-Message-State: AOJu0YzK7/c6tuaeNJ3ZnToRkGu9rAYo7xZWdQGlfPFLSyVnFf/5SpwP
	11ShZGtvvzZicCYpIjYdNVjQ/RVmRjnBPkH87mfI2ObD9Zru6V8STEkYvgGxRApA/SyHdS05shr
	i+6CIJ2/D1NMqxU93jcTkpPyNpn3Px/c5Eu2zpmvOMaP4QgSLdirWuavKpO56tVqtZmfWBWXtFE
	9BpyDAne4NpsNG99Qzle94XYgDQHc=
X-Gm-Gg: AY/fxX5czshYYx5uTEaKDi1V7R1F291yRM46LAp9E+XqGkj0IgLZULzyzKRn6gZHiVX
	cZrGLwVNP6L1WW/cjaNtezk1/BdtC/f+oscjjhisAnisijhzTlFnG9dFF1U4mEpptrT0TNF9YHe
	HowICbi5BEWgvC48iORg93lt99kk4UrBMGe+pdzzI59i0SI1PlsHvpBttJiKfA+EwA/Nk=
X-Received: by 2002:a05:7300:c01b:10b0:2b0:58aa:8852 with SMTP id 5a478bee46e88-2b05ec6d746mr10200106eec.22.1766401022224;
        Mon, 22 Dec 2025 02:57:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHOZ8Mg+irUUx00i70JUySVxbyZwgHrGLx5tvOrAi1bLKJOKaGccjgn0j03pYHiWhdTj5a1Q62kHvVuiw4oyZ4=
X-Received: by 2002:a05:7300:c01b:10b0:2b0:58aa:8852 with SMTP id
 5a478bee46e88-2b05ec6d746mr10200088eec.22.1766401021797; Mon, 22 Dec 2025
 02:57:01 -0800 (PST)
MIME-Version: 1.0
References: <20251221122639.3168038-1-liwang@redhat.com> <20251221122639.3168038-2-liwang@redhat.com>
 <20251221221052.3b769fc2@pumpkin> <CAEemH2f40t+4SsjL3Y=8Gid-CBMtf3eL1egsPKT1J_7LDbdWPQ@mail.gmail.com>
 <20251222094828.2783d9e5@pumpkin>
In-Reply-To: <20251222094828.2783d9e5@pumpkin>
From: Li Wang <liwang@redhat.com>
Date: Mon, 22 Dec 2025 18:56:49 +0800
X-Gm-Features: AQt7F2rMyTWRAgL_U5eetjBYd2cn7LdFDTq8E1pI5bUehmtEffvK18MPJsl7YCg
Message-ID: <CAEemH2fsAmhAkGAQb9rtD2WLUc7QMb9Q5dusG3S8LsJbNKsO_Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as size_t
To: David Laight <david.laight.linux@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Waiman Long <longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qwsH0HW8KkjQyMhy9QCUfuH0MzCdXAhtuu2yZBBwA1E_1766401022
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: shsygd39fd3htz8wemtoo5s3j14qh8mp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA45A1C0004
X-HE-Tag: 1766401025-214517
X-HE-Meta: U2FsdGVkX1921LB0qnroGywgf1MPTL9K8lQcH8U2b1DND6EKQtfxD58uT2uimVqHpOCpJRQY0h06Yog+AD65A8TPknsBCqkoIAFHPvxxu+lXr91hAH2DBHUBABkI/g38MW2YYS74G3TcXg9B3r5hXwxJCwd0jE+aUzr7n1vLUrylJWbryMEUAoI1BDNAm9mSiMIGi5p/ZvKi1+pnpTTAcEDJ3vx1SHowk181RRj3628UYRV5kVigp1NZecOjp7yGAQW1b7xvO+WFETAtd1xjf7qN7XSTJxj+EIYH4ckt+ltKLpe1nKxbefBfKcqTnFIf0X79PppqWJCe/exJUgPIq1UlXFQPEWS9F0MnjqWflgecglfapt3czC3wOJ5FAHGkOC52bE9XKArp9ZT7H6xjxqEBjETDT6qcUN357TPvtt3pT/WOXvufPD1goRRL3qklf5SBGGF+uLKikztu4PuE30aNdpKg/jqgURlHygc8f3G5aichjIJ+IaU5Pp8LZ7/m3LvNPbQo9X7I+BP1Ta5KPC+6FN0vsswlaDpCtOTpT7WbZS2Syie4s5U7cTgGXcSOSBu9kHevLw9ax49nxcBlcWC6cY95oRhWR71LTnhYpTqrgTpOS66JK+voW6ypLIAPxbWGHnWPV8OceJ5J/HBqKd72+UjmHZR0cp5pdAmd9Rlr9ngkH176IuQzLyZiMOrlAXTMnMTmR2xvBu3lRDzj41k+4Dp2P0x9Q1n5azn5mo7dm77JhXqKL3m3LHGxm/BH+uDhqt1973M9iRlxQTupL3mO/E+II/cKPu9S/KBPwI6g31GrxaEeZhWD/yoOckkPdYYSyPsNTReiXLXsLqfHyo6K5Ir0Ptc1f4AZ94ogJ4fl+z8bRb6i+Sfc4GVbl02G0wFR5qy16JRudb7cSbLjSQIRN9RKvDKKc3lLi83cw6sDe8Ac5kBS2XT+OJWKPHt/2J4BaPRbDp2NIoLG0NX
 wiQB/68R
 8cJ0+GsCLVfteuniPv/pCWga/hUI0lfz1nhe0nNhAYnoxgsyFxX5QV2CIfylR6d6B7/WUUQHjcsCyiAjV/spyPFI8AFPZlhLsvjCVXOdP+EgAez6LeUZb0JEXZVohpl3BJmEOVJPfvKWXG9nsj5lpyi310lM3dwZIlT0qb7mVFZzFq6/qesc1E98CCEBbRufU7eTxgwLHsBdH091rXLHiQi4ul6apxiUAP/1qeFkNSEnoaqHNJwU74Bf9T+TndVVrX5ckHRlDl/Xz2PRQQgJpNJHAbqzHOooiYnw6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Laight <david.laight.linux@gmail.com> wrote:

> > > Maybe you could use "%zu%c" and check the count is 1 - but I bet
> > > some static checker won't like that.
> > >
> >
> > Yes, that would be stronger, since it would reject trailing garbage.
> > But for a selftest this is probably sufficient: switching to size_t and
> > parsing with "%zu" already avoids the int truncation issue.
>
> Have you checked at what does sscanf() does with an overlong digit string?
> I'd guess that it just processes all the digits and then masks the result
> to fix (like the kernel one does).

It will truncate the number to the size SIZE_MAX.

From my test:

# ./write_to_hugetlbfs -m 0 -s 99999999999999999999999999 -p /mnt/huge/test -o
Writing to this path: /mnt/huge/test
Writing this size: 18446744073709551615    <---------- SIZE_MAX
Populating.
Not writing to memory.
Using method=0
Shared mapping.
RESERVE mapping.
Allocating using HUGETLBFS.
write_to_hugetlbfs: Error mapping the file: Invalid argument


> It reality scanf() is 'not the function you are lookign for'.
>
> IIRC the 'SUS' (used to) say that this was absolutely fine for command
> line parsing for 'standard utilities'.
>
> It is best to use strtoul() and check the 'end' character is '\0'.

Hmm, that sounds like we need to go back to the patch V1 [1] method.
But I am not sure, @Andrew Morton, do you think so?

--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
+++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -86,10 +86,17 @@ int main(int argc, char **argv)
        while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
                switch (c) {
                case 's':
-                       if (sscanf(optarg, "%zu", &size) != 1) {
-                               perror("Invalid -s.");
+                       char *end = NULL;
+                       unsigned long tmp = strtoul(optarg, &end, 10);
+                       if (errno || end == optarg || *end != '\0') {
+                               perror("Invalid -s size");
                                exit_usage();
                        }
+                       if (tmp == 0) {
+                               perror("size not found");
+                               exit_usage();
+                       }
+                       size = (size_t)tmp;
                        break;
                case 'p':


[1] https://lore.kernel.org/linux-kselftest/20251220111645.2246009-3-liwang@redhat.com/T/#m5a5765349dedfda1ed66c54b8cab7af184bff371



--
Regards,
Li Wang


