Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37A6C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB316B0092; Tue,  4 Aug 2026 15:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64BE6B0098; Tue,  4 Aug 2026 15:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06016B009D; Tue,  4 Aug 2026 15:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7562C6B0092
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:51:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE51114027C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:51:47 +0000 (UTC)
X-FDA: 85064632254.21.F51FBBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id F247240005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:51:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L8/nMWpX";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785873106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZo39pDphjEUJ4S5dknllWZz/LVuNMPSlxO0HEwHOXw=;
	b=j5ylA4pjkY9079BqsJZNKImiy7FbOZx6u8URLgE1eDzKafYvW/U6k8GIE1MXeKOOb0N1u7
	kNRkFnQq58DOrolKoS14aS8wYBOFfzDjkNyM5DaJoqVAE57G4tsKn0eOt6ZDoYWb1FWyLl
	1wMv9Mp4zTwkkefUGc0lkuF7Bd7JGiQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785873106;
	b=fJDC7Bor5FiVDATVWD2HwvuAbmvKOYhUJ/OE74aw0znOreWIZqUhhAjanskGpMVyE+spud
	Pknu5xb1VN811Ez64Q5DekRxj3xFD1FZB7rWIWBfWQI6uQX4n9R81G7jpyHl+4RU9U6iFG
	u9yTUImeO1O1jf0Sx3DqccN00+wesUg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L8/nMWpX";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 251ED41A91;
	Tue,  4 Aug 2026 19:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF01F1F000E9;
	Tue,  4 Aug 2026 19:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785873105;
	bh=EZo39pDphjEUJ4S5dknllWZz/LVuNMPSlxO0HEwHOXw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L8/nMWpX/ejhBaqajLD7Sq/XlkXCgWMOiOBSk9aD2LmVzkEkWj+0p4f6R3XxhX20q
	 wiaiMltxoTFFVzYL1iWMU3Zet3dLdWbr68TX/xm+Qx5fIF0Q9NWFZJMNCnnxsI4/Wy
	 jA0v9nObS+8RHMx+6o16RB9SqZzEbc6YnNb4EqTi8pRWx6mNd+sHbR0AKZPdmYJYL8
	 e4wlWrAszosuzWVVbMM7xyQn3kJE70Ny6yurvzT104wwZj22OvhwQsMMjPWHbr99/J
	 Ws01C+Ojdvb+HmBSJpuaeyD+j5UX7coQG2h+2DL3Pf3opTqD1eUgXJAmadqOyr3uIX
	 RjYyl5pHbfIDg==
Message-ID: <8e48c288-2183-4d58-b69d-5f78344b5da5@kernel.org>
Date: Tue, 4 Aug 2026 21:51:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 William Roche <william.roche@oracle.com>, Jiaqi Yan <jiaqiyan@google.com>,
 linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com,
 boudewijn@delta-utec.com
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com>
 <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
 <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
 <8f787434-5326-4a8f-92d0-467e817a23b4@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8f787434-5326-4a8f-92d0-467e817a23b4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F247240005
X-Stat-Signature: pmt5genu89qr44dipmurfzs8x3mz9kd9
X-HE-Tag: 1785873105-168181
X-HE-Meta: U2FsdGVkX18KsdEslCn5cRAw0VaEmWL7vqufTBpYqMlOUV6G1IPpRYat1aDoGVUsik32Mjhgz3VodmopkQRZ6cArkhn72bqpfwnGzmuM/Yv5tBktyP58HkviZwquLpxZZZzzS68WuUcUgAC858v0zSoIWtWNSaHoN8Wp54ic/ZB1aLzsY/XbWJWTODF+lRBOrAYV73lK7ndH2sekZ/C7RO2jO0xBZFs8CrX9MnkNZJsHNDr/Bn7eAfu0x7uwcCB4/XLJcLPXy6lnISXY5IGi1xaDwff8Bob/OBVdRjvpITT6rVWLceBmsmPNvcaG1w464Gy4Q9krVsp0raEum9lO5QyUsquS1RYx59xSmupiWfjICgzzOjdf/oksD3fBvk9tAtGcFqirtMDE9EKp1Fttue4Wg3tq8WKNXb9h7d68OTkYfBVSZwVw3XhblPZ8Tuu1HeHoW4H36EppQP9iiUsMCt0FrrnBKAX1z9yd2g8pQm/qHJCVjq19E6TuGHJ6wgSNPWJdSCzjgeG73cHLx4FXEbysv4tt2LPKSrKv0liUt+SE1jM7cMH1uUuxEpaHJ3u8BD7eayyRSQCueuwbnamW3ZVbHnylqSO98wywcOCuA/zXZ67SOUKLJb8iDCCxNga39pnV+zYfwJTR7yj5G4V1o8SRyrlAbF3Hn6H4xSBjQhypAbZU/mO9sUrWkssoAo5lvJ1rZUUYxN23Rb6mprQbqivFm/f+XO1OTXiezoCW+twhkjNGLETkKzqIe6VbwhplqRE2l96341aOfduNeOjN97LYEv61mQtfXqU+JRgFttzqj7srZhnaHPl/truXFd4bR/L7r/ZetcYcEYoxnp7Q231rsMlspUmpv1E1plusTU6PaNlnMKSG4fNpsEf1efeXkEh3oPKhBteEYZcAhuMk3qC1h4bBNRpcZhipRUyMvgdMK+QVwjuEpzLaEH7/Zy6wYsTdOpBXmjCCgLMpnDM
 NBSkrbnP
 b+SWirtOsEj3VVCT8OiUe3g3jJShO36qKAuewZPJittYRHK9ONCPEpC1VTWM24hUWyF/pSgBR3ORRWbISOjLtTFysWH6Y4P7ZgHbbjUQJNJ560XQfYYk3vssRzE/lZkRWEKAyXooVIcZbpGsAK2YgNuO2Mx+Mw38e+cR33rBlhy7iAVtvJ1rgRx0rIaoB0b0CU8lQ1a7TqAUa3VyzrMUuMTBiJipccTFahZLUEHSGKVVVo9x86RvPwq+Vc1OgK8DWkQmI5m7Mku147b+WSgyZiD/8gou9gTlQXx0SN/vwD9KQrR4SfcknN+WiO8yQrE9TICia+KMaL2EQtI0FRfK60HltMPFQj2DLp6rzSeXx3Zs1mG4qcnYlE+wUi0JfGEZFPRO1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 19:18, Vlastimil Babka (SUSE) wrote:
> On 7/27/26 16:20, David Hildenbrand (Arm) wrote:
>> On 7/22/26 10:27, Vlastimil Babka (SUSE) wrote:
>>>
>>> Would it truly fix the issue, or rather there would still be a race window
>>> left where we check that there's no hwpoison flag in the re-enabled check,
>>> and only then someone sets it?
>>
>> Why are we checking PageHWPoison at all then in check_new_page()?
> 
> We check all kinds of unexpected state, when that's enable. PageHWPoison
> could have been considered unexpected too, when the checks were made more
> and more optional (first by Mel and then me).
> 
> But indeed it seems the PageHWPoison check is supposed to be load-bearing
> (hi, Lorenzo!). It's intentionally handled before bad_page() (with a taint)
> in check_new_page_bad(). Commits 2a7684a23e9c and f4c18e6f7b5b are also a hint.
> 
>> I think we created a mess.
> 
> Yes, the PageHWPoison handling was made part of debugging sanity check and
> then not recognized properly as load-bearing later.

BTW, I'd assume we can check for PageHWPoison at free time fairly efficiently, as we
touch all page flags already.

Something along the lines of:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 520ebd2fa40b5..57f89f8684168 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1321,6 +1321,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
        bool init = want_init_on_free();
        bool compound = PageCompound(page);
        struct folio *folio = page_folio(page);
+       unsigned int hwpoisoned = 0;
 
        if (fpi_flags & FPI_PREPARED)
                return true;
@@ -1347,21 +1348,6 @@ static __always_inline bool __free_pages_prepare(struct page *page,
                count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
        }
 
-       if (unlikely(PageHWPoison(page)) && !order) {
-               /* Do not let hwpoison pages hit pcplists/buddy */
-               reset_page_owner(page, order);
-               page_table_check_free(page, order);
-               pgalloc_tag_sub(page, 1 << order);
-
-               /*
-                * The page is isolated and accounted for.
-                * Mark the codetag as empty to avoid accounting error
-                * when the page is freed by unpoison_memory().
-                */
-               clear_page_tag_ref(page);
-               return false;
-       }
-
        VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
        /*
@@ -1395,8 +1381,26 @@ static __always_inline bool __free_pages_prepare(struct page *page,
                                }
                        }
                        tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+                       hwpoisoned += PageHWPoison(tail_page);
                }
        }
+       hwpoisoned += PageHWPoison(page);
+
+       if (unlikely(hwpoisoned)) {
+               /* Do not let hwpoison pages hit pcplists/buddy */
+               reset_page_owner(page, order);
+               page_table_check_free(page, order);
+               pgalloc_tag_sub(page, 1 << order);
+
+               /*
+                * The page is isolated and accounted for.
+                * Mark the codetag as empty to avoid accounting error
+                * when the page is freed by unpoison_memory().
+                */
+               clear_page_tag_ref(page);
+               return false;
+       }
+
        if (folio_test_anon(folio)) {
                mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
                folio->mapping = NULL;
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile


Of course, we could also fallback for order>0 to do some smart splitting.


Checking on allocation efficiently is indeed a bit more tricky. For compound
pages prep_compound_page() will already walk all pages.

Having hwpoison logic to just sync with the buddy when setting hwpoison flags
would be nicer.

Then we could (maybe) have the rule that no hwpoisoned page can enter the buddy, and no
page can become hwpoisoned while in the buddy. Consequently, no hwpoisoned page can
leave the buddy (except weird races while allocating, but then it's just an allocated
page).

Maybe.

-- 
Cheers,

David

