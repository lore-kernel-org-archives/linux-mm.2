Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB060C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 07:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC328E0002; Tue, 22 Jul 2025 03:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77CCC8E0001; Tue, 22 Jul 2025 03:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B96C8E0002; Tue, 22 Jul 2025 03:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C96D8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:27:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3CBCB7E35
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:27:08 +0000 (UTC)
X-FDA: 83691069336.03.76E8339
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf06.hostedemail.com (Postfix) with ESMTP id E292D180003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:27:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=pC+ynV3W;
	spf=pass (imf06.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753169227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugX0/5WzJEWczB5ILEP+4F4o+n6UggNVK+OdbQ/Pz+Q=;
	b=5NoB12ZRnvzYqNSJ+RpB1nuymGeGhKFIzOzM58r6iBFvG94xUmy1uhSjhGotjQvpl/uFzx
	NVIfR9Du/2jT3mpKhVbTtciOIAAI9cWFRokly6LGISYBcZ9TWmCZ0uEUkigbk7rsnkAgcn
	OGYwuuJBH8cA6CpK94IyovA5XfzB228=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=pC+ynV3W;
	spf=pass (imf06.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753169227; a=rsa-sha256;
	cv=none;
	b=A282gk0C5vQDkXCzqL+wzhM1CS8GgvrHuMF/gHShA5nFQtp2MXX1OFCE8/TTUxY4fYas4m
	Kb0qajAX2OrmW06JS0n1LaX5uiGZiSCcTVawQHo+x3FB0c6lUdltefN3TaBYIL8i5ih/lO
	TrqS9LodrcI1vdvI1tOO1logIsjKbXQ=
DKIM-Signature: a=rsa-sha256; t=1753169223; x=1753774023; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=ugX0/5WzJEWczB5ILEP+4F4o+n6UggNVK+OdbQ/Pz+Q=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=pC+ynV3WDz3blBMgxiWi5zE0GR69FRJ8BbStpwr8yhq8Uo43covZlsXTNM333REQhI0Hf5F3EMW2WloK+B7KbJUGFcKc1A6NQ+6/Ydwu5fXkE979cUfmKkh3B3hqWzj7pNQ+sTFL5l7t8gINZ0JtUhNK6EGwFAuPYUGTQC3B13w=
Received: from [10.26.3.151] ([80.250.18.198])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202507220927014709;
        Tue, 22 Jul 2025 09:27:01 +0200
Message-ID: <42f7889e-7f7e-4056-9d3a-424298e7df87@cdn77.com>
Date: Tue, 22 Jul 2025 09:27:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 linux-mm@kvack.org, netdev@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <CANn89i+sAgVOOoowNfqxv7+NrAa+8EzkWTVMP8LeGDJ23sFQpg@mail.gmail.com>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <CANn89i+sAgVOOoowNfqxv7+NrAa+8EzkWTVMP8LeGDJ23sFQpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A002112.687F3D42.0054,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspam-User: 
X-Rspamd-Queue-Id: E292D180003
X-Rspamd-Server: rspam06
X-Stat-Signature: 1p55arye5jyqk13kjx849fqmo31883js
X-HE-Tag: 1753169226-874540
X-HE-Meta: U2FsdGVkX1/VF8QSvTbfcahbR4aQZtVvTJI6OdsCNYk1MCSfF5Jc9EVkZ3GsnCr1MIvw++rtrLigZUPu7JCFcdWMiVbmPbT4F9I6qCOOjwL69dSVrpwVDfPC+6J8o5Ehz8K/oojemofKB5TiTz+FugmZbngRYGzSJtX2MdDB0QZ9G0TNaML1iyb8EO+aJaOThTAlhoDzvqHaBhTSBO5W6BmlKLSZbGVtA2zeBjd9q3Hs2I0run0TWyi4xv5FAJjH9AufHea7Gmnzrfj/Bwl1VfAP6MB/T4LLWFNp1V4XF89E4tyNsNfCjGlLq6BVK+ThqhN1RBONkAr7FvwONFK6iI+a4iAt7sj8uV2fDXtKnfkZKiUtFh0EbtSpqjEn+6XtVJ6PhympzV77ljYwB8B1JGECOyNaTMzj0MmC0nRKCYxMnhkQ9qgSnDAebJ2ZhibF54/ooriqWOKU+0Du6J9oCC8nnPwh2tdQNieDjl67XOlsA5o7BXyGOW0oCLNHrrq+xkPJ0Og50UoQtm1YCLhk5panYhJm6abKfeOm5U6Uvo+SVv45EZmdjSpi7/Bj519U4W1s6Q0etvSyuKrObFTU7d13ef1XeASAt7VnytBDUWLop+037xAnY3j7Pp4Re67rEDdrvvebx+HGPE+0eDnV7rtnX7oEoORq0NE5KClRCfzFmuL9JjyaEq77Wf5lwuFgokqrWj68LySFu3/ZDurGqiHHyiTYqCHJXiESVPteoKOqmZMuVeEAmc7s0kgA6GTv3yt2EFfJ8CpMsRlgS3WA430/R9UbrcaJ2IdlYhc+7+tpRf1oHa6l93WHPaz6xmz/zg4poTYQKSo2oHpA3hDVzuE5IQBpUqZ2uDlqoBnLuYyqqafE9ztSd6UJlK8bamVjq68xvafEpeQ3MPvktCLuJbyEM2SJsl7nXDWc2jBaNT8kGkJZaF1NTYze06f5BqX8qtmXciz29z0mvYnqrRh
 ZvdkMcR0
 yK0mSCp/lhgCvyyxYIxoapyfUVeqAcfllWY4tVdRSJSOTJGUyyU+F0EbtfwK/phP9OPSVgpibLlasY2L2crUK4N6cDQEkLyvb+xvUhCS75NC74iQ0qEjfnTkQRZSa8PdJstYVzXLyaigClbrdqLxJ4qTYM07PWmakkDQuiMHNIhQib1+xRDuhn3vcF3/R+aWF9jbbx1a4a3POKBRv12pvmOp+4FOgfYHWAog3XVRcbTDoOCZBv8dt7ghdYYoZisvnscqXmvIHwT+a+RyX7vuVfC2Equ53O2Gj8htymw681hUFxcNrHRjxDI+x3DcncCXwjWPk1bh/JKFPxnWpxkfZkbynR8JMzR/dYHNZJUT/hlyMGfTyPj/GaE27pnUWU0uYP91O7+oR/JnKcxlKigiqq3poYMTc8nZo02ODx/vpucyMNo3H+SHWl0uY5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/25 9:17 AM, Eric Dumazet wrote:
> On Tue, Jul 22, 2025 at 12:12 AM Daniel Sedlak <daniel.sedlak@cdn77.com> wrote:
>>
>> This patch is a result of our long-standing debug sessions, where it all
>> started as "networking is slow", and TCP network throughput suddenly
>> dropped from tens of Gbps to few Mbps, and we could not see anything in
>> the kernel log or netstat counters.
>>
>> Currently, we have two memory pressure counters for TCP sockets [1],
>> which we manipulate only when the memory pressure is signalled through
>> the proto struct [2]. However, the memory pressure can also be signaled
>> through the cgroup memory subsystem, which we do not reflect in the
>> netstat counters. In the end, when the cgroup memory subsystem signals
>> that it is under pressure, we silently reduce the advertised TCP window
>> with tcp_adjust_rcv_ssthresh() to 4*advmss, which causes a significant
>> throughput reduction.
>>
>> Keep in mind that when the cgroup memory subsystem signals the socket
>> memory pressure, it affects all sockets used in that cgroup.
>>
>> This patch exposes a new file for each cgroup in sysfs which signals
>> the cgroup socket memory pressure. The file is accessible in
>> the following path.
>>
>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
>>
>> The output value is an integer matching the internal semantics of the
>> struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
>> representing the end of the said socket memory pressure, and once the
>> clock is re-armed it is set to jiffies + HZ.
>>
>> Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/uapi/linux/snmp.h#L231-L232 [1]
>> Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/net/sock.h#L1300-L1301 [2]
>> Co-developed-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
>> Signed-off-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
>> Signed-off-by: Daniel Sedlak <daniel.sedlak@cdn77.com>
>> ---
>> Changes:
>> v2 -> v3:
>> - Expose the socket memory pressure on the cgroups instead of netstat
>> - Split patch
>> - Link: https://lore.kernel.org/netdev/20250714143613.42184-1-daniel.sedlak@cdn77.com/
>>
>> v1 -> v2:
>> - Add tracepoint
>> - Link: https://lore.kernel.org/netdev/20250707105205.222558-1-daniel.sedlak@cdn77.com/
>>
>>
>>   mm/memcontrol.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 902da8a9c643..8e8808fb2d7a 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4647,6 +4647,15 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
>>          return nbytes;
>>   }
>>
>> +static int memory_socket_pressure_show(struct seq_file *m, void *v)
>> +{
>> +       struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
>> +
>> +       seq_printf(m, "%lu\n", READ_ONCE(memcg->socket_pressure));
>> +
>> +       return 0;
>> +}
>> +
>>   static struct cftype memory_files[] = {
>>          {
>>                  .name = "current",
>> @@ -4718,6 +4727,11 @@ static struct cftype memory_files[] = {
>>                  .flags = CFTYPE_NS_DELEGATABLE,
>>                  .write = memory_reclaim,
>>          },
>> +       {
>> +               .name = "net.socket_pressure",
>> +               .flags = CFTYPE_NOT_ON_ROOT,
>> +               .seq_show = memory_socket_pressure_show,
>> +       },
>>          { }     /* terminate */
>>   };
>>
> 
> It seems you forgot to update Documentation/admin-guide/cgroup-v2.rst

Oops, missed that. I will add it to the v4.

Thanks!
Daniel


