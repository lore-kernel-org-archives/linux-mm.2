Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE64C5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3C46B0794; Sat, 15 Aug 2026 02:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674796B0795; Sat, 15 Aug 2026 02:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A666B0796; Sat, 15 Aug 2026 02:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FBB56B0794
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:35:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91331C02D1
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:35:54 +0000 (UTC)
X-FDA: 85102543428.29.E0FE689
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC72440002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:35:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786775752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zr+5zFui5QOf39o7Ryur3tpGLm216jm+csK+nkkbkMA=;
	b=Y0bx/7e6t2J6o4sp/NWlmOrhe+LM2cFokp8/EOaiL2jn1P3EfT2n3HaBbaVvDirtlsIryN
	mUFMrHYSjqhGfkSRtpSYnah3X69ehMLJdJ8vingAF6d3GCVhGMXKCcLepfu+tj+JCsJ3ZI
	yMGVCt7gPet5md+pe/HDhFptax/ruNw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786775752;
	b=07TbJ4m312SYDbIIC/2cvm1bwvjINV7wTT1sO9+cwOnRAFwrD3HJKG/+zpGOdakiGAdsAh
	n0/uh0xBwb4S4Sic25o0u8FQhf/ubWC1mCZS4QbVtVTFiMUBQTxjp7Z8dSR/fxldnmMkwt
	bAszIqkk0zcYg9V9YYCTECWvw5CojU4=
X-UUID: 85af23d0987311f19a56ed5b684f684d-20260815
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP
	SRC_LOWREP, DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:5d3b5378-70f7-4ad1-b4a4-a831192e5e2c,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:5d3b5378-70f7-4ad1-b4a4-a831192e5e2c,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:565d65f63a1052e78a0145bb396e5f6d,BulkI
	D:260812214231S0PNYE0P,BulkQuantity:1,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 85af23d0987311f19a56ed5b684f684d-20260815
X-User: husong@kylinos.cn
Received: from [192.168.1.116] [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 2089476727; Sat, 15 Aug 2026 14:35:35 +0800
Message-ID: <6c7644ac-9161-415a-ac18-551ff1eb6537@kylinos.cn>
Date: Sat, 15 Aug 2026 14:35:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, linux-mm@kvack.org, akpm@linux-foundation.org,
 shuah@kernel.org, david@kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] selftests/mm: restore enable_soft_offline in
 hugetlb-soft-offline
To: Mike Rapoport <rppt@kernel.org>
References: <20260812120821.523860-1-husong@kylinos.cn>
 <20260812120821.523860-4-husong@kylinos.cn> <anx4NBqyMKwqvEGb@kernel.org>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <anx4NBqyMKwqvEGb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mj61gbjrnsntqt5odbgpdehbztkw93id
X-Rspamd-Queue-Id: CC72440002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786775749-238101
X-HE-Meta: U2FsdGVkX1+hVOMT9ooKH8Oh/CogQCi2GaZXfcy2cvH9Hr0Yo4aZnTaE21REPFG3TEGVbYqb6T5udtABv1DzvoERu4psBq+cDv4I/j69kp6rMKxd0igWhqD70vbbbo4VVAjeCutAseylYZ2gk7u66SAuG8hG8+65LpzRBXo1lMY3P1jMuo8FvCZGJfafT2xsV50jfk4GYpZx7nupFA2fgSt0RMqcEt8l7w4HO1TursXnk5d5WAwRnV5YykOt4JJZ76p9wGQH++jFipT5sN0Gq5r9Rs8S87khhqyyZCPcc0t1y2A26cK7qwpxWyJxq4bdTNcX9Td6xIK/dJUfLa4w2nU4SqIvwJbIkbROo9hrTq/ES1uILjkhc0jQRaWtU2gK3znzR7PmKL0H6ykUrc8ws+FMaWXaPFtvGbH4anWDpW6REKhFTR3uuFCowR1Fhu7Gonbe22wn18EiLslBPqt+vRejB5QvXdNph7uNVoznundW6l1H9u0C7dNEWc8QhL5pmk46InzxJHMSDgK0l+xuM4iOUGg3pK4xGMnBOZzvieddyO1c3UEbJxFRYVxxg8qE/ULA2YcTSMWMGMbfCepN8AOLpsHyhvJ0m/8iyMNy3BH1rgq4DuFZ2pOqtXr42DPH7SVvw8kWVCZVmOBcD20vviENptDRkovD+CO1+b+S/oDuUMm0g3DThe8ADXkLOUlC31/0MYGPakH9jagkOs1wPzU0rSxiMmkVBMN2Uh32AD7bgySlNEz1gIW1AuaBsyn9GxIxHReWmRUA2rTcJMk63AoijQttzLNhMhtWEXsQ42ymXNCelQX9Zc0j9Y3nw2a/JbRKr0jpTmpuDGa24KO8sphHQUxZgqJwFlYUaoH1xOAiX4vIsgVyV95D7IIwIEWYFbdVszIc265kX7EDMyCVOgJ50Y6hYzed73cjq0JVWxmGQL3YIwK569oJ6O3iUTWwq7Vuni2EH4GGmVV28zI
 MAd9C9aA
 sIv6ZqgvlSeL91UETJhqoHbjYDBqKg3BooCHSihXRxfr/5yzPIjo9PPj7CPb6OhGG4D7hggY0Xlj8nN7kVPujWvisaKhV6gGrF3fcy0hZdKw3FhfUqbdaHUVDUyz1ix49x8MM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/12 21:42, Mike Rapoport 写道:
> Hi,
> 
> On Wed, Aug 12, 2026 at 08:08:21PM +0800, Song Hu wrote:
>> hugetlb-soft-offline toggles /proc/sys/vm/enable_soft_offline between 1 and
>> 0 (test_soft_offline_common(1) then (0)) and leaves it at 0 when it
>> finishes, silently disabling soft offlining for the whole system after the
>> run.  Read the original value before the test and restore it before
>> ksft_finished().
>>
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>  .../selftests/mm/hugetlb-soft-offline.c       | 24 +++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
>> index bc202e4ed2bd..35dcf661b091 100644
>> --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
>> +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
>> @@ -99,6 +99,23 @@ static int set_enable_soft_offline(int value)
>>  	return 0;
>>  }
>>  
>> +static int get_enable_soft_offline(void)
>> +{
>> +	FILE *fp = fopen("/proc/sys/vm/enable_soft_offline", "r");
>> +	int value = -1;
>> +
>> +	if (!fp) {
>> +		ksft_perror(EPREFIX "failed to read enable_soft_offline");
>> +		return -1;
>> +	}
>> +	if (fscanf(fp, "%d", &value) != 1) {
>> +		ksft_perror(EPREFIX "failed to parse enable_soft_offline");
>> +		value = -1;
>> +	}
>> +	fclose(fp);
>> +	return value;
>> +}
> 
> We have read_num() in vm_util and write_num() that can replace
> set_enable_soft_offline().
> 
Will switch to them in v2 and drop both helpers.
>> +
>>  static int create_hugetlbfs_file(struct statfs *file_stat)
>>  {
>>  	int fd;
>> @@ -185,6 +202,8 @@ static void test_soft_offline_common(int enable_soft_offline)
>>  
>>  int main(int argc, char **argv)
>>  {
>> +	int orig;
> 
> Please spell out what orig is this.
> 
Will rename to orig_enable_soft_offline.

Also, per the error-path issue Andrew pointed out, v2 will register the
restore with atexit() so it also runs when the test exits via
ksft_exit_fail_msg(), like hugepage_restore_settings_atexit() in
hugepage_settings.c.

Thanks,
Song>> +
>>  	ksft_print_header();
>>  
>>  	if (!hugetlb_setup_default(8))
>> @@ -192,8 +211,13 @@ int main(int argc, char **argv)
>>  
>>  	ksft_set_plan(2);
>>  
>> +	orig = get_enable_soft_offline();
>> +
>>  	test_soft_offline_common(1);
>>  	test_soft_offline_common(0);
>>  
>> +	if (orig >= 0)
>> +		set_enable_soft_offline(orig);
>> +
>>  	ksft_finished();
>>  }
>> -- 
>> 2.43.0
>>
> 


