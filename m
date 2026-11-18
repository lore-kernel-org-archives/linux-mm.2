Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB743606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aFR2MfWy
Received: by kanga.kvack.org (Postfix)
	id BD6436B05C2; Wed, 18 Nov 2026 17:15:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86916B05E9; Wed, 18 Nov 2026 17:15:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75606B0602; Wed, 18 Nov 2026 17:15:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 660506B05C2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:15:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8DDB808EB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:15:01 +0000 (UTC)
X-FDA: 85449646002.18.ADA91A2
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id DCD131C000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:14:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aFR2MfWy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795040100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrqYcsAaNhX6ls8KpPsAOf8ZByUQtmFTbu0qydlAKkA=;
	b=PyXSItp6lPOF700Gb98RNJl11oY6M9mgMaj8kRDqOGVY/CQso+Ej+4lJUFexxtPJopENWA
	CmOkopVxPQEIY7jNyH9TYVqa3aS1FYN0LdRYvsrlDgw7bqy/auTABTgJv9d8X+eOlJB4N4
	Drr9BKWEn4/GfjPVf4Ifprof7VDC2DQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aFR2MfWy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795040100;
	b=EPvdTxnfg5MgWiJNTatnswFJUD9R7lDDKcDn83TCVy17eZvOlMC3jojGv7QIlGkoXEj/Hb
	AoJiBvOm1hQ7jNQA/tm1jGwUf3++YLCAYOKcB7/GbHx8CkxytCCpqXHVZ8tBwJFZ1zrms1
	Teacjog9gLpyH9y1/dkw+lUpbPrfYU8=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so4061735e9.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795040098; x=1795644898; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vrqYcsAaNhX6ls8KpPsAOf8ZByUQtmFTbu0qydlAKkA=;
        b=aFR2MfWyiT1UwHVFyX/oW2rr+gZnlqoT/YuX8ld9tOtlhM9R81u47IPh3LDs+1fAtF
         t8oEc0th0a6LmiehajstrzcSh+4MGxehajlXvLwnDzB24GOTe5QBxgFjzWYjHQcTaIEL
         pcqgh6Jr581s9EICIjPZAdR/Bz3P0/60stHtW/nuB3n7iaKCriWyLFCWXnCof0KLOX4O
         7D4Dd/BzLiGP/REAgnIi6PuFHQ6tP9bhpFnHca6LZ1aJoXFkiXQ1Zi070xZ0RrQjJrpH
         ep5LD2kJH91An62RvhPLOWfbZe9zhtVu2sJoR8wHnW31+TXzWyQo3WL/9hWmIcS2Guaf
         AJWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795040098; x=1795644898;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vrqYcsAaNhX6ls8KpPsAOf8ZByUQtmFTbu0qydlAKkA=;
        b=QpcBgAagXqqXe8gnP0MG3+ayI9IwAxhoatMHE1ZJxThmIXwYuITAB/csWhaXNJheXD
         yf7jWNnMoxb33ssD2J0SIzVnNbK5suG5qq0WobFkBIJ2DpThPGreGw/SMyldTMAPjFK8
         RiF2RQc0q+DE49DTVlaAjWT8Upv5QRBALXQ9w94wMdHwkzWQLTgoBLYjk6EYZEWvLAwQ
         mnIl1ruwyEpyuGbs5XDT5Ket8Tv6Gs0eVns6VVJJsC+LYlMtQZ8JitfvpxnvUv1knB7U
         fWcO7tK4YSSKrgX+6tGs0+RwKvGL21YgJd99/P9AmBDYht04EIbbaRSbXTHj3CVKy0X6
         68sQ==
X-Gm-Message-State: APuU4Z/qiO9BkLLEViGrClIQqSF9zi07TBJpJNCH2PfVoJbXtLgKRJRi
	IZaPw8h9bMrUMmsS96f1ZkdmC+OKW1gmQMUBC2wNQebvbajBWmyuBaWD
X-Gm-Gg: AYBFou0Sr4MZzowXpPXu3p0wLO34vNMHvzCzzL+V07MNbs7IwJG4lmL7Kp3xVKkpcVD
	YBTj5ezr/+EFvI2d9rKGh7uO6BEwFhC+zzPoxKg0mWfE0xUIrHn9+158VWwnUieM2QLwSwtDhwW
	AzvKPHZxjKdNISS6Mordnf0zDe81gf2EeEOZsPL9ZBMV4gpw4jD1HgNKGx8pCVy01C8PcT43nri
	dg42TbSTHyLIa1X73Ep4T+JqjCux1y2AM3TdLxQv3UOMz8RRkrf0BOFBMm7b5QM2/9ciOKaU5Lk
	hL7nEJYa+uEbDaORhh/lLV+vrrRVouQqie6duN+y3le0WMZGoUGrQIgX76/ReZiM8EjoCWs2Y/O
	YE2ePyqH+TxgSjJFFBAiWh1r+v/vmrE4TT3lzolqbaEkbOs5faSd4vLgLztexQxMeP2aamqEaFv
	n8Xcs5awYzJsXSHw++PZu2na7fzjSgpUnmmlmx+1+WR2KiREFDhCMJmQ8lA7INa49T8XyWF6jK6
	pUpvyQsZB9nECYd06NeMhzdqJqpaWIZtfqFCo3hHWqQ6HHSxBbFZzFM607GRLXt7d6H7LxzOpEE
	PcE8cmF6hZBn12uxFSmoeRi3
X-Received: by 2002:a05:600c:3495:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4bb8325d81emr16614185e9.10.1795040098228;
        Wed, 18 Nov 2026 14:14:58 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d4f5b87sm65370135e9.2.2026.11.18.14.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 14:14:57 -0800 (PST)
Message-ID: <efc129de-f238-4253-aef2-f102d9704025@gmail.com>
Date: Wed, 18 Nov 2026 23:14:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: reject DAX mappings
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>, Jingyi Sun <1045704958@qq.com>
References: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1qoengkr74u8txyo4q4adtbsuiy1fu71
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCD131C000F
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795040099-390807
X-HE-Meta: U2FsdGVkX1+29CvqVaKmZ4qIffAkiiVgiywbWfWyFSc4qed5+2ryZ9ZwAhgYrs4EseTq4+aycXD2A9gH/QpYW2mdccn/uByD3N84hZaHASrEfjg/U2EDA4wtMMwjSFnGnZ2tEuoRVmp3rXq4BQXxReNio/LEMs1/iOeLK4RVTeRqkF1b54CnVRgU6YOGP/vggFBd5YLT1uJ7NlcHHMxh6IH5SAS1wiZpzC4r8JgHc4nzGZVj9133poQTZOrx5cAWfFTdB6BtBLyGbN94zI/jwGe0AxdltRXdLgqDXygUY9zBzfWJOKDCo7QR8yxM4xiS9C/mz8ilkpz5h0biNIs8vVNWPvCn0YZdaEU/K2XQZXd3QGEbxsboAlyRTnP4W7CE0fwzYKL6xYdQedhrq2UC4oaz4vXO2jnZDbMOuomlEZn9pA+3dOHKpuWqWnRpoQpKCMt6iTAyfxxdjC1CnyFoDyEZA8YXVOa0Q2w+BtwXAc2a9uoi07AN2rHEydXib/H+XNp/p25JHvT6vC0jIKOeoRXhIGSWPsiJjCyTky9+NRckDxWbAn53HBQ7fYfikNOaypeYyOGgnlo6Ved5hCticxv+wRbALyZtk8/gIMFAWXz9MhFZ+N5VxZHZnmukoZbKsLbKEA1nBpRThPDxUKwZoCdTYHPAqFdrVEa9Lk/EO21kPVCvtVjygJI5sn20oMwNx4+SPDR67iSrZP6UTG8wl1qGb9Bi862YBMdzV14jIAIO3ygjmKI/rEZEW3n9q8vzyi+LqE+Ay6optT4AuyqTr7Knx8VJ8c+/yRtAI8YHc38x/wZrFw++Qt9qgrpyknXoJlvjBnAHtDEjpsjKJs4f+1kiUXaypV525HMavSGwYhSWBG/HrafocDCwQoYiZLy6MxzyryA4BGe24PB6FqKk1ObGKbMI54UCxlEUyRt2+NjVnetc7egHRHDQNpz3IKVDxFvHqzcDlP9ns3Vvy6+
 P7DY5j5U
 reUKULSUULUsvJqfCGe4vf3TcFfc+pf3dPXpiDXfCfGf1owTyt0kTT832kHELO7t5kQmDoeeXZKHvVYYedkUDO8DPclGFkI82mysezjnSYaPNPyO/VZdS02fAXphQ6VNy5l2kUQbEKoV8+qay6VEjTL9FPIZe+RiRfMC759RIc+H8NPO9FtdSaGJNCWHdqjgTR1bkv0EoNg+fRzqK9egfUStd0WYQh5h3nXjc09bJLyps7m1wXh+J3gGJKjF08GkPSU+5aFbbgSxbOU5guCUKE6b+bv/h6y/BqAk7JV10bOtN7TI+OoQFT3CjkcWKWD4InjocfvfanR+TGl/XPSrLc1cNxJTYKoCSY4LZ4fh2mN1u8VSdiwWvllvRn8DcQIrlkiwsRWjiPRZKIPLoWslUjloRyQB50u53A7TJweD83TelhizHbYCMktW+84YUrQSd8jtV8wXlm2M2kinVW5cs4rs3LOqX8wRgsmsCRE/DZMUZecJbFYQ3EYx/vmnW7Gpj6LBP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 11:03 AM, David Hildenbrand (Arm) wrote:
> UFFD_FEATURE_WP_ASYNC made DAX mappings eligible for userfaultfd
> write-protection, but the DAX fault paths have never fully supported it.
> 
> DAX faults use vmf_insert_mixed() and vmf_insert_mixed_mkwrite(), which
> treats any non-empty PTE, including uffd-wp markers, as an existing mapping.
> A read fault on an uffd-wp marker therefore returns VM_FAULT_NOPAGE without
> replacing the marker, causing the fault to repeat indefinitely.
> 
> PAGEMAP_SCAN can also write-protect a DAX PMD, but the huge DAX write-fault
> path can make it writable without clearing its uffd-wp bit, breaking async
> write tracking.
> 
> Device DAX mappings requiring huge-page alignment and cannot serve PTE
> faults after UFFDIO_WRITEPROTECT has split their huge mappings.
> 
> So let's just disallow DAX mappings in vma_can_userfault() entirely,
> making UFFDIO_REGISTER fail with EINVAL.
> 
> Fixes: d61ea1cb0095 ("userfaultfd: UFFD_FEATURE_WP_ASYNC")
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Jingyi Sun <1045704958@qq.com>
> Closes: https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

