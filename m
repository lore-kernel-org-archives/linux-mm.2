Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31D3606A339
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f6fvVZ61
Received: by kanga.kvack.org (Postfix)
	id 0BF586B09B3; Wed, 25 Nov 2026 06:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070AF6B09B5; Wed, 25 Nov 2026 06:12:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA13D6B09B6; Wed, 25 Nov 2026 06:12:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4A856B09B3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:12:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55732160DC9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:12:13 +0000 (UTC)
X-FDA: 85473377346.23.38400B9
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6013D180003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:12:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f6fvVZ61;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795605131;
	b=61D5wm7JgTdM9iEIXYOlskk9YFRQ8B9Zw1Ep2zRZIpc+zjDVZkPzggrLUfgPfIaLIjikdK
	72vtoIaX8AVpYST1otgMNoVhFUDkbtGfAZIul9dUsJ9jbmKMrP80uLEpX6z730yIN7xsJH
	VkYNyDntw091E7uxG83j9chnzvg5skU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795605131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cO/MJUe6DrmL4p32qaNL83dldbBryQjDhwfZKwkiD1Q=;
	b=e80cgZjwF6a6Mv6OCouFA7+dp52UPshmIlrQFWymYM2y4dPdm/vRuCghd5+4pEawcOde46
	Kyca6MVUqmKDL51se8kRkHXY9aFCNPZQyHOYDUTBMoyG+LIbTNbHbSWmWcsyrCMZh032m1
	Zf6llGz9LF6G5FFQemX7N9HX5HT6xvw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f6fvVZ61;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso4951410f8f.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795605130; x=1796209930; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cO/MJUe6DrmL4p32qaNL83dldbBryQjDhwfZKwkiD1Q=;
        b=f6fvVZ61V0hvS380yE0oTm0eHAYS2a/Ekmbuz8ztJmt3Z+HhxtB8AF8lnfr7Hn45Sn
         NXUAm8X2D80SrcVT+nmQIEGnHN5Kw3WRXKjcTHwN8+978Cw0CKQDNeqEOcL7jyeF0HNz
         pg4sTWIYlExfAZs7S4etpqRAnM/1CNPKVblUy/KdFd2thw4y3ASmb9MOChIVfdt6LX0O
         I6ziN9Dkz2KvdB5pT1T96I8VTRlI9crU3s1TRcXKzy/1/TWEIdlmTnwshZbGwnl0t8bf
         g0esWhaDGaDYAsZD6CTtxbIYfjhXTQP+4gVyXyIkUQaDeb/MmpROb5+AC2aDya/xDpJh
         534g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795605130; x=1796209930;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cO/MJUe6DrmL4p32qaNL83dldbBryQjDhwfZKwkiD1Q=;
        b=2A2IImOr/d2NbZduVliUH0ddMKQuUITihHoYj9QSAv41x4EB53329o7cJ2RtdQBI2G
         oNGKZa/noK6rivx/tSIO0sNq/+ZhMEn/i8tXOjIEB7fYJCZco+mD8gA3kuXe1TUdkNPL
         /ciEgPk9v/S8WZ2Jaz3XX/HY+uqLz9iseEQB+6vNDDiify+0KCuyTVPca1tHUpkIxdm/
         WOYGP+nsxgbgFj4NvCqPyyt86vkR59Ov+ww+K/cpnFWoaUT92j8jpgEoWEwW2ISlHTeu
         Xb3QDmPHHPO2hWBYB0lO0nRaFotlzIzsH9vt7AlWDluo7X9zFTHgTSblMq4VH+3MohBe
         1Pww==
X-Forwarded-Encrypted: i=1; AL+hErGVEp79+GORPjCSoID73a2Nv6HoQaYXk7p+dppdYh7+/UqGtx5nm7ycy50ykCzKHrFzc4++ilj1+g==@kvack.org
X-Gm-Message-State: APuU4Z+eMlWnnaN16H5JlSNSnbU9o+EqtdZE6t0qs8grGBTaqBJayiz8
	fixujQrgaaPg5yQNG25347JhZXHEij1l+9Q0wjTvsH1iVE1BWYEJtm74
X-Gm-Gg: AZFdTZcnn9vgQn/8ejIwuAWv/UeFmNrPaMB/axWwVhrn8YHtACkZt7u0UCLjaxQlwHu
	VLSC99VrfUOXhZ2+dF+CW3jsL8Atj8KeayXdrwL4nwLoZtharSQH2bwwqchCmuLUcnbjanz38E7
	KItvNC8jnq89dCzon7h0ZKZ3V0CrGwSsP8gCeigz1DvqB4ClaAEs35WaoKijyZwPWvgoGY9cjG9
	JkSZ1pi/WdRCqEVt7Ab9y7uPAL/mDs/9WcSRB1RBye7EgPeh5PdHpxGAN0/31G9ZcLCn9QMoYqs
	FyfDquXXyo3mUhLlL6fO0gFzrO9+PoUN+SZkD5TgTILjXxU+aJ3hxCakBc+qE01Fthn3Dil1mZh
	Me9rglC61J+cArT1B9jlBLmu9/PRGaAdS8cBBkJDF/YweaG1hDQ2gvZbk/Y+HFljLC7iQ1sZVMG
	Sp4/z059MS+cfQ31jIE835Y5ryS8kbfzHKapg1fV5ahtd7r2+G6kZ+R09KwwLiINjS35pKtrDPj
	lINXhRK8r3PEFg7tv/E5eSqACxpvQTZxemyUjUgckSLrLGaXlGUYbeMXs+1+x8OZbWzrOvTiEf2
	yeB3so1BK6dDjpE+VoHMguKc
X-Received: by 2002:a05:600c:8906:b0:4bb:a60e:a316 with SMTP id 5b1f17b1804b1-4bba60ea355mr25237275e9.12.1795605129542;
        Wed, 25 Nov 2026 03:12:09 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b8429sm802287835e9.14.2026.11.25.03.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 03:12:09 -0800 (PST)
Message-ID: <66fd4450-6e17-4a1c-be76-38758a62073a@gmail.com>
Date: Wed, 25 Nov 2026 12:12:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/khugepaged: use NOFS while collapse_file() holds
 folio locks
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Zach O'Keefe <zokeefe@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kas@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20261125100058.15200-1-azpijr@gmail.com>
 <20261125100058.15200-5-azpijr@gmail.com>
 <8c60bed8-6857-4361-91b5-c8fed8a083c3@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <8c60bed8-6857-4361-91b5-c8fed8a083c3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6013D180003
X-Stat-Signature: t45xnzss1gh8qefqbaqt56miyjwtnqoj
X-Rspam-User:
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795605131-587086
X-HE-Meta: U2FsdGVkX19llCiine8bkHihw6AIvp91W3+K1e8ER28DPYtxwOO2PiPhC/OPCyLNMZXUeRq+3ToznokVkZsIl99LVwKh1mCW+6JtCSgceELED5fKqrLrNaukJ/hs+SI5PokQHQp691DJXbvSBtDFrODs8kymywTvwbEKvTZxe7o8PQqXKRVQn0XcGSdUE7fHltvD1FXjC0EktU110nyMghXJi5Wbw2oC35DcWVLFIQA+UAQcYTerjNL6AVPaFS5TF9Vs1+sqx9S8DIbBLbxsxjs3627OgJrG4l0GjPQTBOuGLpbVud2c+CjzjxnEyMsiK64tA9l6bZACRfnIYgBhiEnJui2gIO0erxrkesk9rfab0yyl3/OjPCP53r0b66bPCGrE3QqoT4C+DYD2zKfPcMxBT1YZwHLFl8CpBAa3b/cQUXxRrDxZ259ue77/ZCwomMX5DznhqgNY8wXOXGiK9fUEjXb+g9crLH9z/6HVfMPAT4+ywUBMz6CSKe9ZgtUy42+abB6Me+mvBcDPJVEfHxKzZCjCq4kB+uVHHUBCMISlTcbr09eH15cTTmYPzMjw5VkyiXNH4x7SbKJ6geSTzm/k1VppVbVhaQZdVk8PqisbeSfbcAYoxNEePbp8sa9w8fpUJAMj7drfOxhtdpRtizyuVhQNxygtP/89RALDCi5VQ5JjSxbIcmSsdZh016yfQNYXLuvpCQL0OaEYlBn6t6rA9oEHXB5dEf7Lo0X55oL3FN5Fa5PgqBVpY9ElAZEKOpHtBqD2lCBdpa14aCl4gzMH3RSa0hnSR2CTu5p66wtBFIrDegc8H/iVWpRVVo74fqmdzLmMgtT59ppY6y9+jQGVhGz665hKtUm0vlEhyxpLo9njxjQAAQvsYSK4JPtNpM5LqzpTbA+DkPVQX6tcDmK8Eoj4xO1X8StMiG29bjZEeERvxwFSQzpHmKJ4l9WIdTUskpd5lkcPU2rndTt
 GdbiFPHj
 CurF2eriI/a6VghV5527bVmtSQJb+ZzmClS/G3xaVSwl/9KjliLHPN9UAvCHEhcXz4UjBs9IFuTH7Sg79NaV1fYYI+zmIqDP6JCj2M+aflpWA7uWzD6vfQrTqb//mYxzmA0VoiKhaIHHiYmIOY+eI0eLOMHYOD0B6ecepaVhytd/UX6CX9WpFRxZmgdUzD/JZdzwHHBA0KS4lg4iLzoPNo24IjiqqrOvH3Jt6gje1HYAnbzGF3I5aeb/nhEO6mLSOCQGqLxJ3OQEHu6mMaWqY3WtH1uyh2HTjIUngIwoa/g/wLMzIJLumUHFiIkmzoAk/VfW8W/QBcFfMDkrAGBrqoScZqPSk3B+egXk2kbkdd4uSm/Vgr3eksPn8ATPdkk3FP/uFgOAq6VvrqK41fv6c4TLLb/mHD004NrP/QCa5V1Nxx520jHXRk1Dt0WuHXdgyzPMrgSnRAww9klrvK/lEE/jg3jXjM2Tk8zDhN0a89SVHA2Uy21TL4QSmSGSb+t1kg87z015pQ30oqlzoR4QZ32CpeEq28AHFu1gYlDBxidpy4O+PPH3IZkU783szZd/ztIkLFRwxc6eRS7FaJ3m6lgXI0OUvOtOex6ikysakLbVvfVvkvjnpxCqXEBkrJprQV4/6FOtMi6ihPiKIvnAkgW+nu30L+rphvfIAWOz1WjxmAUj3Dl3rcyj/7iyvxBx/lr20IVWtLZilIy6ZsHUGIol0DgvgnN7RT6XYTq+zSKAQ/fM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 11:55 AM, David Hildenbrand (Arm) wrote:
> On 11/25/26 10:59, Jose A. Perez de Azpillaga wrote:
>> collapse_file() keeps the folios it collapses locked until it is done.
>> With those locks held, it calls filemap_release_folio() with GFP_KERNEL,
>> and for shmem it swaps folios in with the mapping gfp, which includes
>> __GFP_FS.
>>
>> As when splitting folios, allocating with __GFP_FS while holding folio
>> locks can deadlock in direct reclaim or compaction, and __GFP_FS also
>> lets filemap_release_folio() wait on the filesystem.
> How is that possible with my fixes?
> 

it isn't, sorry. I'll drop 4/4.

-- 
cheers,
jose a. p-a

