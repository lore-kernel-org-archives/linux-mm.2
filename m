Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A548606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KWHBNMTu
Received: by kanga.kvack.org (Postfix)
	id B1DE96B05C6; Mon, 23 Nov 2026 12:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5676B05C7; Mon, 23 Nov 2026 12:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4696B05C8; Mon, 23 Nov 2026 12:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8335A6B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:37:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24BB51A095C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:44 +0000 (UTC)
X-FDA: 85467091248.03.CEA527D
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3D5BA40007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KWHBNMTu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455462;
	b=3lXJDB3V3/49P4rGnrSzktxiU7JtJxTXVFzAj4c9WG9jmeoSJRjHGpOFibs7igGS8sQJa3
	djhtloziZNES8p+DaMDVQm2j1ZpJDrAr7BW49Bf0dgGOM65flBWBHnGeC99rhZk9si2NB2
	uFr595mHivUAzlIOE5Rw4ZLcwSORM/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZHBxkIsMI/Qp+ucOhJHKVnTKpB2RmQ5oFbvkHFx1xQ=;
	b=5O8bJCoeS6R7cQOykRyS0bGR91K6FZvzDCC8PFRlveqDCZiwxCShaXhTv4sqqUj91nSpmR
	p97bjR64HB7iWUcMfMzsPA9ZhfxR6YsT8bEO+rbe9VxRVL/8NiAJB0T3kTtVQxQrIoQM3q
	/wNsi7sdq7OP3xL61JSB3PyKTSpDcow=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KWHBNMTu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a6ce64b95so1376115eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455461; x=1796060261; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PZHBxkIsMI/Qp+ucOhJHKVnTKpB2RmQ5oFbvkHFx1xQ=;
        b=KWHBNMTuekOcSCLCo+fc6w4lAdlnwJfnWb0WTPs4yhCXmPa9fpG9WwzPSuU2CGPSLW
         t6ReKgdI7zwiHapvlsTzxFukRRYN2XhEV7hs16h/cGGqCqCZJWnR/4XrQLuM2V0K5xk+
         0WuqXkmNznVyaPtjkaAp2tl+Cx4xyq1+x1hseNT6HhaYyRpM/ZfIRG0jQuQm3xfCoyuh
         wv8Mt8N0LbukZoQ6qp+bCARDUW/15cL+bcvMd0F4KuCi1EJNdOBnTRsgqtGWwp6dlcd2
         4SMsD0pkTcfg90bUiERjr0ArhorynfdR1bB65AQMDXktqYTue6U4rGGbjdhjwqDaPpx5
         yY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455461; x=1796060261;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PZHBxkIsMI/Qp+ucOhJHKVnTKpB2RmQ5oFbvkHFx1xQ=;
        b=LLoV+CE33ZQAHjyclmNb/pQ93DffegEejbP3Hn0ph8GE1O06WbM9chlQTh3EGFCGZH
         ISBp9SIBoI/cm7k0e2q9cZcpQgVLvZj5Clxcqoar8egy5xF43QoItTDEcNOGKvTI+VdG
         0+4AGGBfkQOVynpREIbpTguYIjNFs5CWQ5MJu3eiyYNn2HFMc75J6v6aFLYhSQaEDSLR
         9BBdodUQwbDXf1i/WOvPxRzlQDWo+zXmqSQPZ5qpbBObctTAXxk+TLp2R9Tp304gRRqt
         rneCbs/me8FWDi4dn8RSb/CQyDTGLzauh2icQEERjldy41wI9n4B19EcshtdQyhIzIRa
         DS8g==
X-Forwarded-Encrypted: i=1; AL+hErHlLqeNdPLb/smd6nSb++NWee/moodZuqe8F9zG+LQqG3jP0xY7/Q1dInTGmApJhgn+9n0wBQ+KAg==@kvack.org
X-Gm-Message-State: APuU4Z8xtzUwxEmnceMLURYtE8VsHxTpkIkiTt4HloRTR5mlKIQOZA7n
	4bJbfSj84LNj+AeNvTYN1eHD1CdeiSVI8sHJhu2bsmXfOQ25IwLTSLjf
X-Gm-Gg: AZFdTZdVCF4y+f1T2Rjs31CCiKcG8ppnERw2FyDzJpZ1J6+H9zNE+J2bE4dphYUAWWi
	bYtSLuq+hMq1Bz655MRI9MhKzEdC9DGyMsFomJizGlfg1ImoqvN0JQDY+Wc0Rp9K60Lxp/ziyJb
	G3WINHcOCY+9Pbc1vkgU+vIDHvLnkFTuN5UmUZYiHdvC3Fr4fsB2CLnqq7VF57JSdM7hiZCUgDq
	ehzqOwjzuxTgjeUNIJJUY1R+pgVJVq1YI5Mtvx0qptIyQKdDIMLR9QJ+j5qcsc5grXoOsi2kZlC
	YkTtMUas9orBTqUjXz/fPpsoLLCy6qHD34cdUyAr66tLd/nnk6elKaSY9fivykOIGhrk6NP5PGW
	OsZ/GViaEob1mvXrgHItRCvMef9lh7DN0CP3BC9rv3ZPuO7Kek56M0cTIuq4EjKKYclpDZ67o/9
	Ef+hwcN5kQgBJ8mDFn1v2WPDEOelZB6dP7q1ySH5+Ifpf4hla/AfjhHOCvhIlvgbB+mj/ECxNx9
	CrTz1l1DOrh/bJUg/d9CC7aKte+jXformoo7OC/ADmCdsHghOaO9csCzPD/lUk4tRmch4NWylKo
	OO2zp1ud/HTmv8XjDB6yE/EbTe6D/PkCAO4KnAG392t3U9oK3bxEimUhj6tAOg0l1sQ7WoipgsP
	kNJTvuyRrkK0OH6zSQNIP2Gpta2zoemzyO0QZ+2Jq/kuJ0m+Fn+5/p/s2wK9x2Q==
X-Received: by 2002:a05:693c:87d0:10b0:386:b823:d6c0 with SMTP id 5a478bee46e88-386b823dab0mr1978021eec.4.1795455460957;
        Mon, 23 Nov 2026 09:37:40 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:37:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 17/27] Docs/mm/damon/design: update for report_made
 probe filter type
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256508.4.18069260923134156169.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261121210013.130397-18-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-18-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: ux634yb3nffm5yhsfspq4hb5f5kufaj7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D5BA40007
X-Rspam-User:
X-HE-Tag: 1795455462-561649
X-HE-Meta: U2FsdGVkX1/jN7KXDHhObDhI/eOLwPkB2xYK0dYERzFtIsrEB5mgpc880YrXgrZn6iVboq8y8/kH8CUmIVT91tuAYc0NZZuShS1U3NtH+sHUJpiphDUckOZ/hvg5Q/RV/oInAj93F8GmwtxZ924TNeDWrIhkdcU/fEZtoFFThCF6UfMMgpOpYUM0/STPxk5pdfGJhlLle8S61gA5G22Y9TYvMfr6ra1lmSDdV3eJFE2F2njKdEUqWKQDqIol2f1uyGhhUouEy+fNaK8gzO/xNHmKTdqFCBIPMEMZ3LSAmuXAPXsm+e7BwDj7m+nSMnyxNCx8h15kPNRPiEzrDH+WJ2QeeexGhY6rY8qq6eoLQNL2oSO7N2J9IOHxiorYdIb1TU8QC/BqSALrMp2dYoYHL9MwyrkBOkAMdUSESmkU6iB97Pp6U6QcxgGqjFnWe2EqhrpCFQb0x89OEoKrx2ctYH4ZbKVj+iJ45qaJZIA6pEpYvYU2LeGN+PIiXIZz3XmnnBpqVC07ro+/naiBL6Pj90yEi5eKj0TOy0dzmFFxfxjZHFFD78GiHHwezSlj+Jy2GHCl/wWVcaNxcYLy15otAP2JKNUNGCUYBBs26ENFvO3P/ReBmvcDyKkV7xTI1i5R+UgN5P/O/l/baHWkISa2weXGBGXk2Nq9rHoSXT5Tff8RZJi4tP4/sspaQz7ED5kl5X3tlBslCbqleo8VZoR8vg8PrPwHhcXLMJRTtuzfLAvPuUiSJC0D9BKBloSVWpx3AiK9S67kBAknmRv3V/SncTWQtpUvtwFC1QlTMo3SU0Z2AlrP5VXzwG3Tz9maxIitXM4G1/Pw6gliYrtgLUnVSI7tqLFrrDKm6fB0ksAU/GxRmw8NLfSwOTPW2KCrEPdCkrtr0SsJqjIgAYL+ZMOFMcJLkRQM6Du3ZKYuvDuVfVi4EcneVLfkr5o4YhpXo+N1bTmJ729mu6qggcwr/He
 nZZVang7
 NERYwbpHmTdt7SSgGhWVs+uFPulrrXTzZ4VLh0GMI5nlw5PNByGXqPbZOHFOqcpvVKxIvc+GOYZ0aTWE8bS2x1SEX3aKiscdIyKtbAsmQenB8/MgAqaBqi/p05EeqPeu90euu7HYOVesi6dET9tmWo3LhMWjGhtlNuyh86bLx8B9ooXCv31DLmBbl2248d9IgCBXLF98DkQg6pUqxSdqsH2TVR2aPfuzV7U/yN8w1OJMIrl/jKdkH1W7Z2VQvNQMNIxmL6R5Gn4M7y+bp9SE6Ok88K/jd0aoPLygJG9hya5tMc2E8qtBJ3w/wpHhRTh1YMaeEXZ8gG28SiIhJhu8oW+uaBBJE/dU/vGUINbQGGsKci5thwUm5xgJNFL+qFKXa0VoZoOhOMW15QhvqKcagc3O9bVqVA6mbfFxbEjQ12e0FNl8oQolrmYnrKpgrWgAU8R+M3joz11tYGPwlAfTsFOYVvDvvIXh5OHcNSqsIyMQZeu+v4BFKZfDiWDDjyzj3CiGd7KLh4pT5fnpG2esnvtdTWF0SdudG9tWb2vj3DY0HkaVCERUX9HK1MV4YxXUUuuXT24x7YeDSpLAZsgGKjem5nAq8YgO5PymER8uaFKXpdP91nxivGYavN/CVWOSmXg/AX3HZpnp6HKttm7RzqTF36h/myQtWv8U33ETxv5EZKDt0AH+vu59JfwKut9Sn2rtfoLUGAReQ0PXQYVgJEX41zrFlLCPw3dR2OpllmY6r12cnqPCUPC/0+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:01 -0800 SJ Park wrote:

> Update DAMON design document for the newly added data attribute report
> existence type probe filter.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

