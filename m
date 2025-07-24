Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853D5C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D8D6B00F0; Thu, 24 Jul 2025 17:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213836B00F1; Thu, 24 Jul 2025 17:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1296E8E007C; Thu, 24 Jul 2025 17:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 044926B00F0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:27:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C66B9160313
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:27:11 +0000 (UTC)
X-FDA: 83700443862.24.E048346
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8F6F100007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:27:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=U8rKlAVk;
	spf=pass (imf05.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=quarantine) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753392429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrQZvefTT8J72h8dUnTdsjaXor2WmZQIMIJXwY4LKOg=;
	b=lxr2uI+V3xFC5ksjMrc2q5xstf8xRCP8sPsF8pH39Q56ADdK0ODHsK+Fqxv8GOvdagZK++
	7BsaHsBhQ4ln1wuxJ1V9vpakD6dMbOyQivn2v8gnG0xqGigqY4pEhb4baHhlxvNz86zUgf
	iuJZveR1QhyUPZfR5/U9wtulF2kAxVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753392429; a=rsa-sha256;
	cv=none;
	b=PKlmhgJs0Pr/OHxYfxwiAHcLnZFOj526F9EpEvaKVLmuGVmO9MYWZabjh4fMrs01PAIp8w
	TCRUiSXAea2qzgfhoHPMAu3llt9OGFOYuNTT3tYD6QG0YpBtYnaoKIDoS4Vl4QdPfKyHmY
	ALwu2zfxaRkKVJYElVvsVH4MlrPQtus=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=U8rKlAVk;
	spf=pass (imf05.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=quarantine) header.from=broadcom.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-700c7e4c048so21362476d6.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1753392429; x=1753997229; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BrQZvefTT8J72h8dUnTdsjaXor2WmZQIMIJXwY4LKOg=;
        b=U8rKlAVkGh3kG/xULv9LZG+Rtc24Mzae59ZLuwCIzf6U2/kx7GTQEomOjZJzlgoJKR
         BZVCu9pabGMSVJiI1LCS8xLGyfbgW517A6xw185AEIlpISzvQo55dobOkFRcw9Hx+BAf
         vnVqzmd5S8InT7Chw//QKyh4mjEEe1UIFPjPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753392429; x=1753997229;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrQZvefTT8J72h8dUnTdsjaXor2WmZQIMIJXwY4LKOg=;
        b=T2gAav1BJ+zA4ojDlX7kea+NIXS8uLBO7hKqGzIxa4d6UislW71yg8WphdpaDVoTFx
         XK2u2ddLofKG3Po850tnue0z9cMyZvyYbCtMFTCthqeI1Q2fNY7NbEFrs1LWHBby7U9j
         O5X2Q6YEyd4xXBLGb1SKdUbPxcb5k8pbilsCPMs2Ge80RHwS3enr1t15KfpEyDH+E3d5
         FLHf8NVPeZfNSjE082qyl1erLN5IDjPIKucMYJuFQmuyqBH6SXjvzP/FCjlo3Ylq4L4A
         wMdgP/8X2nn6+yiMRHenvJyUPYN/QMWXL/d8AhjSm1ZF/NJ0Mptyr4m6u4geRw0M0VTm
         JIDw==
X-Forwarded-Encrypted: i=1; AJvYcCVFlxtRCBXGqgJPXeb5NsQ79AajuFGfPjKjPRVHEbSeZswimBhbfop5tVN9TyVWyM27jfNWZHPYiQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7CpjkIil6oIdnD7cf+CdkKUmpEcL1DBz/0d8ORrku982UXMEl
	NqSNUmJn9UXfbVwldM1MT5aMBfIat4u8vW5w3fM1QAr2gD4+smzTGyLTeI2hToRKWQ==
X-Gm-Gg: ASbGncumLc9yvSvzH/VxVcb6PPHrtUzWv9DGX+NqyV7AXmmWB1hPg0MAGyR1OajQ3gb
	sWiGgGjt87LOsCGVOfbtE49feZhiEoTjn05n3AkAxFVp3DJ1+/E4e5eosxyH53mcvMoERunn1GG
	KBXgPA7EyoLiaJu8mXXGRrm70buYpkWxcDKul34xBNfI4xqwqSdZGJ984CW8GgJT5c5g01pcU+w
	FQXUUCfk6Uxl6MuK6dEZfX8Kvj5UPHAcHzHvgjme41n+wqrgsZeJ1igziftGqTvFlTgFlnPL3X3
	1DVWU0lqMlrTFCpg/YIFUpys/ZfChF3hqEA/AflXQUHU+XIJ0/UKfpOfLpjymy1V7UfSbgBfMUo
	O620gWw5GK8u9dd+1sfZNsq/ewwQ8L9Dtzx7uTySzIRSJrYQ5tgJeVQL1JNFPlA==
X-Google-Smtp-Source: AGHT+IH/5Hg4SYzXScd2JZ5u442inXbwL+/GXKWv2N03daX9+cThsM2yzxMXOEyM0Xu49jU1K7FUEw==
X-Received: by 2002:a05:6214:c22:b0:706:ea6d:e161 with SMTP id 6a1803df08f44-707007167e0mr108054966d6.32.1753392428572;
        Thu, 24 Jul 2025 14:27:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7070fc9d5e3sm18704486d6.53.2025.07.24.14.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 14:27:07 -0700 (PDT)
Message-ID: <f084e692-7fd5-417c-8e49-860c2ce47d33@broadcom.com>
Date: Thu, 24 Jul 2025 14:27:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] MAINTAINERS: Include GDB scripts under MEMORY
 MANAGEMENT entry
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham
 <kbingham@kernel.org>, Michael Turquette <mturquette@baylibre.com>,
 Stephen Boyd <sboyd@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 John Ogness <john.ogness@linutronix.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Ulf Hansson <ulf.hansson@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Sami Tolvanen <samitolvanen@google.com>, Daniel Gomez
 <da.gomez@samsung.com>, Kent Overstreet <kent.overstreet@linux.dev>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Uladzislau Rezki <urezki@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Etienne Buira <etienne.buira@free.fr>,
 Antonio Quartulli <antonio@mandelbit.com>, Illia Ostapyshyn
 <illia@yshyn.com>, "open list:COMMON CLK FRAMEWORK"
 <linux-clk@vger.kernel.org>,
 "open list:PER-CPU MEMORY ALLOCATOR" <linux-mm@kvack.org>,
 "open list:GENERIC PM DOMAINS" <linux-pm@vger.kernel.org>,
 "open list:KASAN" <kasan-dev@googlegroups.com>,
 "open list:MAPLE TREE" <maple-tree@lists.infradead.org>,
 "open list:MODULE SUPPORT" <linux-modules@vger.kernel.org>,
 "open list:PROC FILESYSTEM" <linux-fsdevel@vger.kernel.org>
References: <20250625231053.1134589-1-florian.fainelli@broadcom.com>
 <20250625231053.1134589-9-florian.fainelli@broadcom.com>
 <04116d0f-2815-4583-853e-e4295fb3d014@redhat.com>
Content-Language: en-US
From: Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; keydata=
 xsBNBFPAG8ABCAC3EO02urEwipgbUNJ1r6oI2Vr/+uE389lSEShN2PmL3MVnzhViSAtrYxeT
 M0Txqn1tOWoIc4QUl6Ggqf5KP6FoRkCrgMMTnUAINsINYXK+3OLe7HjP10h2jDRX4Ajs4Ghs
 JrZOBru6rH0YrgAhr6O5gG7NE1jhly+EsOa2MpwOiXO4DE/YKZGuVe6Bh87WqmILs9KvnNrQ
 PcycQnYKTVpqE95d4M824M5cuRB6D1GrYovCsjA9uxo22kPdOoQRAu5gBBn3AdtALFyQj9DQ
 KQuc39/i/Kt6XLZ/RsBc6qLs+p+JnEuPJngTSfWvzGjpx0nkwCMi4yBb+xk7Hki4kEslABEB
 AAHNMEZsb3JpYW4gRmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPsLB
 IQQQAQgAywUCZWl41AUJI+Jo+hcKAAG/SMv+fS3xUQWa0NryPuoRGjsA3SAUAAAAAAAWAAFr
 ZXktdXNhZ2UtbWFza0BwZ3AuY29tjDAUgAAAAAAgAAdwcmVmZXJyZWQtZW1haWwtZW5jb2Rp
 bmdAcGdwLmNvbXBncG1pbWUICwkIBwMCAQoFF4AAAAAZGGxkYXA6Ly9rZXlzLmJyb2FkY29t
 Lm5ldAUbAwAAAAMWAgEFHgEAAAAEFQgJChYhBNXZKpfnkVze1+R8aIExtcQpvGagAAoJEIEx
 tcQpvGagWPEH/2l0DNr9QkTwJUxOoP9wgHfmVhqc0ZlDsBFv91I3BbhGKI5UATbipKNqG13Z
 TsBrJHcrnCqnTRS+8n9/myOF0ng2A4YT0EJnayzHugXm+hrkO5O9UEPJ8a+0553VqyoFhHqA
 zjxj8fUu1px5cbb4R9G4UAySqyeLLeqnYLCKb4+GklGSBGsLMYvLmIDNYlkhMdnnzsSUAS61
 WJYW6jjnzMwuKJ0ZHv7xZvSHyhIsFRiYiEs44kiYjbUUMcXor/uLEuTIazGrE3MahuGdjpT2
 IOjoMiTsbMc0yfhHp6G/2E769oDXMVxCCbMVpA+LUtVIQEA+8Zr6mX0Yk4nDS7OiBlvOwE0E
 U8AbwQEIAKxr71oqe+0+MYCc7WafWEcpQHFUwvYLcdBoOnmJPxDwDRpvU5LhqSPvk/yJdh9k
 4xUDQu3rm1qIW2I9Puk5n/Jz/lZsqGw8T13DKyu8eMcvaA/irm9lX9El27DPHy/0qsxmxVmU
 pu9y9S+BmaMb2CM9IuyxMWEl9ruWFS2jAWh/R8CrdnL6+zLk60R7XGzmSJqF09vYNlJ6Bdbs
 MWDXkYWWP5Ub1ZJGNJQ4qT7g8IN0qXxzLQsmz6tbgLMEHYBGx80bBF8AkdThd6SLhreCN7Uh
 IR/5NXGqotAZao2xlDpJLuOMQtoH9WVNuuxQQZHVd8if+yp6yRJ5DAmIUt5CCPcAEQEAAcLB
 gQQYAQIBKwUCU8AbwgUbDAAAAMBdIAQZAQgABgUCU8AbwQAKCRCTYAaomC8PVQ0VCACWk3n+
 obFABEp5Rg6Qvspi9kWXcwCcfZV41OIYWhXMoc57ssjCand5noZi8bKg0bxw4qsg+9cNgZ3P
 N/DFWcNKcAT3Z2/4fTnJqdJS//YcEhlr8uGs+ZWFcqAPbteFCM4dGDRruo69IrHfyyQGx16s
 CcFlrN8vD066RKevFepb/ml7eYEdN5SRALyEdQMKeCSf3mectdoECEqdF/MWpfWIYQ1hEfdm
 C2Kztm+h3Nkt9ZQLqc3wsPJZmbD9T0c9Rphfypgw/SfTf2/CHoYVkKqwUIzI59itl5Lze+R5
 wDByhWHx2Ud2R7SudmT9XK1e0x7W7a5z11Q6vrzuED5nQvkhAAoJEIExtcQpvGagugcIAJd5
 EYe6KM6Y6RvI6TvHp+QgbU5dxvjqSiSvam0Ms3QrLidCtantcGT2Wz/2PlbZqkoJxMQc40rb
 fXa4xQSvJYj0GWpadrDJUvUu3LEsunDCxdWrmbmwGRKqZraV2oG7YEddmDqOe0Xm/NxeSobc
 MIlnaE6V0U8f5zNHB7Y46yJjjYT/Ds1TJo3pvwevDWPvv6rdBeV07D9s43frUS6xYd1uFxHC
 7dZYWJjZmyUf5evr1W1gCgwLXG0PEi9n3qmz1lelQ8lSocmvxBKtMbX/OKhAfuP/iIwnTsww
 95A2SaPiQZA51NywV8OFgsN0ITl2PlZ4Tp9hHERDe6nQCsNI/Us=
In-Reply-To: <04116d0f-2815-4583-853e-e4295fb3d014@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A8F6F100007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ukzmw99b6osw3ocs7gsaq68u6mignn3f
X-HE-Tag: 1753392429-755309
X-HE-Meta: U2FsdGVkX18ClFIBYaT6uIsdzonNie795IPbi2Ru1zowEKerYZDfYdsWZlQpO3W/Go0jB/9xrvpc+ZqDSguDMdWaTjm7vbJ/peUBkJqPD0SS/vuatIGFt1z5mho7wNNs7iRAoGKd3nUcVk4wYmMawOYbWYvU4lQeTO8QtfPk+R/iMXP53bg7dTgTL1Fd/dqSBzNhJRYiB6wAIGb/TqChTPbEcQzRBIY426Pw79PiYnE3iOWQYFZK+a7wBOGjDqssMohmXtrfAkTVANplFSWS0lHyITPwoyc2HOvLljElEVLv46x9IY582fuyYdMyzkGBsNrvL/0Mf8ib2WJTnD2CA4Q5ojMXe9heHkBo0uoJItifiFhmB7fyv5xKSEJtjrduIYsl4Ra6KwQhKps8ztQ3q7WKLmyVhmHm3a2QvBw+AUyykq9B4AXBdGsFSduJRxGvDA2LS5SMB9/CeODbqu/6KZ8eGY8oyinqQrUUJ9TBQTS0R5OQD4IqakwCrtx5SE2wg5IA61X3KoLUiRxXE4WHgfZiE5uCM8hqvgXfIvH3Q0ZCi+aL+vV2sXAKS5VY6AW4TXu+Jv+jiQipWustqsnVAgorNCWg4xd6JfkjPgmdzXmZHt8PkV37aYlGJ/H8gULwTm7vXNHAVD/7lpkFHJOT/rMP6yMXNs1r7zb+4c6e3pftIIlForkc6gvEEWfLRR4sgIWknjgfsiIt4F5rbP2siXvtIgv7Bx8YKjBqNSAidsCHNR3jnRtIyOIPC0M8FxWIbkIF5bGkS7GcgCxZS+W2wtWmqGNuaoIdFNjB8w8NXzAK157gI4qe5X+gMOQDLq/XRSqHLVD6wrRMZ/uqq32Y3LOcDa8MQBIxu/Whj4aAQ5xnU/pggEZnA13mwoZaI07/Mx0Pm2CGluIMW19FxGJbFceVUtDcuTfMiSd0h7QtG66e1FIcWXvFMnKpddMkLadLkeIKbc/0P294sromIJ8
 Gh8U3K7O
 GDP7t8PFhkYyYhELUiE1C9lntBqGzqvpB8tb/j8jSyFDpPDt6VzjjGZq9HB817FEPakEclxbYZMrVMeCI7/e8dNFfGLrSdhIzR9MyWpsWn1+aP4H9V8Tr15Mkf9XMpsx0S9on6IQVJ9DUNgO3PbUjlY3/wAP+kmXMRnv+ChO0/PFcFsgO4xtJmIgL9ZYuWINRaIFcqUfXpcoHKnA1iLJeGw6SJTOswfCJpFlwpS2SgT74BqWJ791ek1lLtXm5HdHE5DT2+awgcQIcpjIZs8tHRRxx4dnFrl5gx6/MNCbcRlvm7if94dTyHXvUYPNWko2wqyZvpFVVcX3Yqj1e/eIGo+DqeAql/wFyaY6S5JAY8MwMMeEPrIE585XDS/x8aXYKNrRxl+aWF1MEnVxm7L/mL+nQobb7HjhTPuG430sIz9yPFoxuFEIf3NEE2/K8znxEweR+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/27/25 10:10, David Hildenbrand wrote:
> On 26.06.25 01:10, Florian Fainelli wrote:
>> Include the GDB scripts file under scripts/gdb/linux/ that deal with
>> memory mamagenement code under the MEMORY MANAGEMENT subsystem since
>> they parses internal data structures that depend upon that subsystem.
>>
>> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
>> ---
>>   MAINTAINERS | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index cad5d613cab0..52b37196d024 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -15812,6 +15812,10 @@ F:    include/linux/mmu_notifier.h
>>   F:    include/linux/pagewalk.h
>>   F:    include/trace/events/ksm.h
>>   F:    mm/
>> +F:    scripts/gdb/linux/mm.py
>> +F:    scripts/gdb/linux/page_owner.py
>> +F:    scripts/gdb/linux/pgtable.py
>> +F:    scripts/gdb/linux/slab.py
> 
> Probably they should go to the corresponding sub-sections. At least 
> slab.py?
> 

Sounds good, thanks!

-- 
Florian

