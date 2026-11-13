Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3ADE606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=FABUw9KL
Received: by kanga.kvack.org (Postfix)
	id 0BB636B065F; Thu, 12 Nov 2026 22:16:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C616B0660; Thu, 12 Nov 2026 22:16:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4126B0661; Thu, 12 Nov 2026 22:16:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE1C66B065F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:16:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A6601A03AE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:16:01 +0000 (UTC)
X-FDA: 85428631722.28.2A3E48C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A64B140003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:15:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FABUw9KL;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf23.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=evers_chen@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794539759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UWPlGM+o3dWohOnvym8E+O+RQOw/78ZpY1zfq1s7e8=;
	b=7h8nB4KdpL3aahB4tcohURcd2wllS9EktM1JCnktefYkThxwjaf8L0o6eliAJu5EmS2hb3
	E8YkLrGyFExdGh8CTxOEOkzOmA+4Ks86s8usP2MWx6+tshEQ3XzX98Rc1ldm6nt2Hd1HhC
	gwzNXMaIWDk+UjlQkGW94S3LiUVYeUE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FABUw9KL;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf23.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=evers_chen@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794539759;
	b=5zFp0ZtJNN9UV2tOjp3w+IvpcWZk9kYdsqBxWa9zKdE8+DPN/tQXI7ouaoTyNBZH2jvVZU
	T/YONMU1OYG9T4TNCPXfM6Pl6OR69zTZg43I7kgRn/TU83d7+4mWflPJqe37HqF5mbW8yq
	UsYJOvFmO5HfjirtMneW5S0BZ9HoDTc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=5UWPlGM+o3dWohOnvym8E+O+RQOw/78ZpY1zfq1s7e8=;
	b=FABUw9KLHI8dQ+h33m7un8kvF8PX/fOjoTrVjKb3/d9iuT6VHxkMp1c0catLy5
	0qvI6EQ3lho7V8B3Eo/h4ftoEA7mNtzaTpbJcJlkiR+xUkPZj2vxGep38myDo6HT
	c5lnquD+/hyLK0lVpVXUqjitx0w5ccliFSHGkWJsd5euI=
Message-ID: <94f0b18e-6bee-4aac-a396-fa5a5eea15fa@163.com>
Date: Fri, 13 Nov 2026 11:15:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Handle implicit read permissions in
 madv_populate
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 chenxionggui@lanxincomputing.com
References: <20261112031811.56500-1-evers_chen@163.com>
 <20261112113231.ce39807d300f102e6763a87b@linux-foundation.org>
Content-Language: en-US
From: cxg <evers_chen@163.com>
In-Reply-To: <20261112113231.ce39807d300f102e6763a87b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD31_XZgPZqXZLhHA--.33600S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtr1kJFy5ZFy5KrWDCFy5CFg_yoW7tr1kpF
	WUWF1YvFsYqa47A397uF17tryqyr4fCayIqw18Xr90ywn8Jry3Kr47Ga4F9a48AFWkXw15
	Ca98u3srKr4DtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ukb1nUUUUU=
X-CM-SenderInfo: xhyh22pbfkv0i6rwjhhfrp/xtbC7ByvuWr2gNxqnwAA3T
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A64B140003
X-Stat-Signature: oxkfkddk6t7484zs8wyi4s8ckqaziiy1
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794539757-560151
X-HE-Meta: U2FsdGVkX1/Ndli+F/0nd0whAEkUB3vxZwTeTQ2It4WUlSxRFr6FQ8ZlarW7b9lqNXPJDEKWBA3OPUtdCIvwTjx4lPMTokfVyCCQSu+fgkrz2zF8+I/a0PCRZUYCHC3U5jlPKmc/88G5h0fkI7rIaZXX8X2ZLr6hpfRvJRGHNKrv6zy5Flv7ezTS5NZ4WJC0BXi+Yu6vCezHqp5+l57yGDQOZSfWtLT3KPqNg81BCs0rJ8dMBBynoY3Mq0+gpAvTH87kE73wmEfKXNph2D1FFV3FuC4T8Th8sCuPG5EJYwIt4NKz76N5+iGvCSmwzzbzU41f7hTsTPGhjPlJLN1QZmoy3zFKCopT4zICC0wUOlmaJ3tYx/4ByOMmrYIND7l3s+EqQR3Eg+EJ1Fo4yZYn/yKJlHInX2LhfR87tbH7b+ElaCv1FOFSJw22uf7h6VhabEBm271UaD3Ttkz9uLk0g81KBxeelOiHj9lgPLYdh9erp6KAlxwAKvaLw2D4oDa1HwYf7AtW+HSKsJoIvQo7RE5De9kxJBzVmRJzxszwfQ+jx37oSqt8CX+txNyCH8yB8xEhksY9V+txRqRE0E0+Eq0OO8Rb2MSIsi9JW49oYgLstG+sUInLS3chC4b6GYx3zc91lXFl1WKsZzKCHeVvFhUXsDXmqMHJw6z9jcnpU7EvkTVCDIlYP4Dc0UkR7Wym9oo/OYazJQu+0+O1VIZJF8s009IyeRzylgLy5mSsUAwJDnZsdh3yyj/0/kNqtm8kGMnAARiGedJKwnD9BomwHBBZE+FlijKeY6fjWn/SfIaNF0H4cie689Fqkca5M4HzoB4xjcVYZso3TsxHOqiwCT6QE4M3qQEYSfsZPauFnIkZkSPd3pH1yBjLmOjiJlpaJ5INyedOCi3opLknsuIXyTUS3JpOj96uvzN3OIcRdgeTi9HCAfgf9dbTWyNjGHbht4LVcQlASh2p5s2ggdB
 UwHTiDCd
 B1n//ov/0p1CYY/MnD6PwG2mG3vat00y+S0XnvPCZ0+e5ZcpFi20TjSkpQq1WiTG/QfzOH5iHGFHSvON4/NZiGAK0/Dny5FC7WfGeWp/wsx7LAb2h5AARpNetT6em5MxjwGiBDPeWZoKrnzZRmmyT7CL9a2NzM/9ZYaDeUazXsxBiaNs3axK2X9Tn5L2AenhlCOSScr6VgpIakxMInju7mt65JCfkEDzzshweX6LOoo5O5cvGL0W91EIb3NuwtkpQVQvSTP2mkEXa+PKIA3djjg05+rgk/LvINbKhaH4qpwxoGm+Ndx49RJ+XmDoJ/n8enCrH2NqRsXxeGuX1Gx+U1E/4qSwLxnslIWBrXiVZ+x8ygxyOEPJ9lLjDzCpJ7BcPkaj9W3WT8flrhYcZN4J4LdRkfYslDOKtjtqbykR0tK1Ea5jl4P/ZrufUOLigCQXbEK8T5zDRizEbkkU5Xpfffu7qmgPmGzyWgvP++t1+98PDYmP5ZA6JIf2djgoOJmu6KQD/+E7YlGtwmbNGikpaW5pcBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thanks for the review and for improving the changelog.

The revised description is accurate. It correctly explains that the 
behavior is specific to RISC-V and that MADV_POPULATE_READ depends on 
the VMA permissions rather than the hardware PTE permissions alone.

The updated changelog looks good to me.

Thanks,
Xionggui


On 11/13/26 03:32, Andrew Morton wrote:
> On Thu, 12 Nov 2026 03:18:11 +0000 Xionggui Chen <evers_chen@163.com> wrote:
>
>> The madv_populate selftest assumes that a mapping created with
>> PROT_WRITE cannot be read, and expects MADV_POPULATE_READ to fail
>> with EINVAL.
>>
>> However, some architectures, including RISC-V, may implicitly grant
>> read permission to PROT_WRITE mappings. On such architectures,
>> MADV_POPULATE_READ succeeds, causing the test to fail incorrectly.
>>
>> Check the actual VMA permissions through /proc/self/maps and adjust
>> the expected result accordingly.
>>
>> Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails
>> with EINVAL for mappings without read permission.
>>
>> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16
>> tests, while the updated test passes all 17 tests.
> Code looks good, thanks.
>
> The changelog is a little imprecise.
>
> "some architectures" is too broad - this is purely riscv.
>
> The wording suggests that a readable hardware PTE alone determines the
> result.  riscv can have readable writable PTEs without setting VM_READ,
> and this test still expects EINVAL on those systems.
>
>
> I altered the second paragraph, please review.
>
>
> From: Xionggui Chen <chenxionggui@lanxincomputing.com>
> Subject: selftests/mm: handle implicit read permissions in madv_populate
> Date: Thu, 12 Nov 2026 03:18:11 +0000
>
> The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
> without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.
>
> On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
> VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
> with PROT_WRITE.  MADV_POPULATE_READ checks this VMA permission, so it
> succeeds and the test fails incorrectly.  Whether the hardware can read a
> writable PTE does not, by itself, determine the madvise() result.
>
> Check the VMA permissions through /proc/self/maps and adjust the expected
> result accordingly.
>
> Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails with
> EINVAL for mappings without read permission.
>
> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
> while the updated test passes all 17 tests.
>
> Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
> Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> ---
>
>   tools/testing/selftests/mm/madv_populate.c |   67 +++++++++++++++++--
>   1 file changed, 63 insertions(+), 4 deletions(-)
>
> --- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-handle-implicit-read-permissions-in-madv_populate
> +++ a/tools/testing/selftests/mm/madv_populate.c
> @@ -69,10 +69,38 @@ static void test_prot_read(void)
>   	munmap(addr, SIZE);
>   }
>   
> +static int mapping_is_readable(void *addr)
> +{
> +	FILE *maps;
> +	char line[256];
> +	unsigned long start, end;
> +	char perms[5];
> +	int readable = -1;
> +
> +	maps = fopen("/proc/self/maps", "r");
> +	if (!maps)
> +		return -1;
> +
> +	while (fgets(line, sizeof(line), maps)) {
> +		if (sscanf(line, "%lx-%lx %4s",
> +			   &start, &end, perms) != 3)
> +			continue;
> +
> +		if (start <= (unsigned long)addr &&
> +		    (unsigned long)addr < end) {
> +			readable = perms[0] == 'r';
> +			break;
> +		}
> +	}
> +
> +	fclose(maps);
> +	return readable;
> +}
> +
>   static void test_prot_write(void)
>   {
>   	char *addr;
> -	int ret;
> +	int ret, readable;
>   
>   	ksft_print_msg("[RUN] %s\n", __func__);
>   
> @@ -80,9 +108,19 @@ static void test_prot_write(void)
>   	if (addr == MAP_FAILED)
>   		ksft_exit_fail_msg("mmap failed\n");
>   
> +	readable = mapping_is_readable(addr);
> +	if (readable < 0)
> +		ksft_exit_fail_msg("Cannot determine VMA permissions\n");
> +
> +	errno = 0;
>   	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
> -	ksft_test_result(ret == -1 && errno == EINVAL,
> -			 "MADV_POPULATE_READ with PROT_WRITE\n");
> +
> +	if (readable)
> +		ksft_test_result(ret == 0,
> +				 "MADV_POPULATE_READ with readable PROT_WRITE mapping\n");
> +	else
> +		ksft_test_result(ret == -1 && errno == EINVAL,
> +				 "MADV_POPULATE_READ with write-only mapping\n");
>   
>   	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
>   	ksft_test_result(!ret, "MADV_POPULATE_WRITE with PROT_WRITE\n");
> @@ -90,6 +128,26 @@ static void test_prot_write(void)
>   	munmap(addr, SIZE);
>   }
>   
> +static void test_prot_none(void)
> +{
> +	char *addr;
> +	int ret;
> +
> +	ksft_print_msg("[RUN] %s\n", __func__);
> +
> +	addr = mmap(0, SIZE, PROT_NONE,
> +		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_msg("mmap failed\n");
> +
> +	errno = 0;
> +	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
> +	ksft_test_result(ret == -1 && errno == EINVAL,
> +			 "MADV_POPULATE_READ with PROT_NONE\n");
> +
> +	munmap(addr, SIZE);
> +}
> +
>   static void test_holes(void)
>   {
>   	char *addr;
> @@ -266,7 +324,7 @@ static void test_softdirty(void)
>   
>   int main(int argc, char **argv)
>   {
> -	int nr_tests = 16;
> +	int nr_tests = 17;
>   	int err;
>   
>   	pagesize = getpagesize();
> @@ -280,6 +338,7 @@ int main(int argc, char **argv)
>   	sense_support();
>   	test_prot_read();
>   	test_prot_write();
> +	test_prot_none();
>   	test_holes();
>   	test_populate_read();
>   	test_populate_write();
> _


