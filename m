Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42FFC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E366B0169; Thu, 24 Jul 2025 17:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743CB6B016A; Thu, 24 Jul 2025 17:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A026B016B; Thu, 24 Jul 2025 17:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5677A6B0169
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:27:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9F5CBA09B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:27:30 +0000 (UTC)
X-FDA: 83700444660.12.CEEFD3A
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id CCB76180004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:27:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=IRs4Sq6r;
	spf=pass (imf24.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=quarantine) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753392448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eb7LwTrwfKZRGwsWl7FQwuOc+LHKc/Q1TZHaaM57R8o=;
	b=hEKJjzhZlQDDQvFxM+vRQnR4mJS3U+LydvaRoQXxj+5pwy+mc6FkopbiKyfDOqtJd74Y+2
	ttYN+G1SOZATsHMMudG3jC9A3bJh7/fFq25UlBLAP0dj0TevWprFrV48GfCKPtEH3i/qjw
	a8f65qh4P20WlVQSGIMk2J3oTkgncrU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753392448; a=rsa-sha256;
	cv=none;
	b=ucozluUz2225TcCF8O+t66nXKsRizLIp3zzLURkRRcdaleiSbqKnPy7RkAfoglizey0NsL
	8dUMqdzzPBspKheNVbBJt3bgc71IERxUJ+AYH1BwOHoMSO9MKdiz45mU4eIANa3kNhCy/g
	qTQcsZlwTaWndXO5rbkDXS4fhcEn1Ns=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=IRs4Sq6r;
	spf=pass (imf24.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=quarantine) header.from=broadcom.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6fafd3cc8f9so17889216d6.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1753392448; x=1753997248; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eb7LwTrwfKZRGwsWl7FQwuOc+LHKc/Q1TZHaaM57R8o=;
        b=IRs4Sq6rLAd5LPdojVv0tsM/UjLDN3+35AzW0Bjx7I4H28uWAeONKo7DcOpgUpknCL
         Cv4te3LzPDazbxhQaf1P+pIuoiMLOnAdLcjNH0dvL8VX2o1jUp8nEsYoj3bjD9qr9Wwj
         3doGuYtUh+0a6F2NErjO7UnzakQE65BK6eRl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753392448; x=1753997248;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eb7LwTrwfKZRGwsWl7FQwuOc+LHKc/Q1TZHaaM57R8o=;
        b=C5yFfx/UcTeCQKMHF3y5SKfQ4QRlljhu19sY6ctuDNEobOhax9k2ceY9y68LHt1iMZ
         UKeHEOeKjN5Be/7xr8HYMOn6XgDgUyEBNfHdH/XJf3HXoirYzhQy8iycFac2Mr+mM+tY
         9KmfhzVQgItu2BYvrB6zDuKp3gJhFRJ5e/zgs+ERUGvH98SmIRKovv1kU+14PLZtrC6v
         sZAfvTgISIGO9zjo3VX+Ir6wzqph/c3ZFKYAROvTqqeOR2X7p0wq68K3Gw3vPfW8dDfj
         8mMabPkhMqCwvc/T0goBBK77bHLCyJaVfpncVfx0wPZcUca/lItY3bK7J+VfTG14TVJP
         Ga9Q==
X-Forwarded-Encrypted: i=1; AJvYcCViKqLpqCiHxgcr/s8G1KgjZXL2hOQpxeskHMvqQpLlyu8b2/0g4v57QixIowmW1EeSkKkid2Hh/A==@kvack.org
X-Gm-Message-State: AOJu0Yzdp0UPTjNGT3DfEb/L2kaKJqp5WydSUwkwBdXDpCj6Pm+osYLp
	kjDFSz0sASHu76Egcy8rgL/vpiO7gMeI3f42oCJj9Uxl7U8yCA5bfJrqgXU9U/8h5w==
X-Gm-Gg: ASbGncul/70VPdXkSim+XzRTlLnwNG1n9G6nQiQUOEuWYhb5/FotMOqnnvSAG00tGKm
	w5ubxA2sHzy4lRPGjA0wyDzrOe04jeHgRjL9WNMzqCEixyZ4ee0DZwEu4pQu+eHlQbhUNGh/2Lb
	xZqMCIV/pbfifdIMy0ubxxBPVLpmclhE8ckIBrT3tfx/GOtW1ctU5FPuyD5vvYsR7rd0Be7IMUn
	VTW4aJaoSVkYtBmv4Ok0N/pTns9bRgoOHIb69ZA5jwyXRV2XvfZJ1tdk1Ty/ADqDmttaQ874bxe
	bZOWidKS/1P9dfPEWhetwDdf8W2JBikDMgqOCsfEvv5tQouYeEdelkqMuBalHmDwXmQ03jRtam7
	PCFdbZj0pflLWVQm9orakmqfqPiFx9y6GuaIVSSySQGjY5wfICgLDItNA7UXFS/x0ZJ59qgiF
X-Google-Smtp-Source: AGHT+IFXe1AUozr/VBWe0gYnK+qQoY2TYFea6yXJGINXUcVKLGT6eNnGYGkrp3ZYYhKBw7J09w5K5w==
X-Received: by 2002:a05:6214:500d:b0:6fb:4e82:6e8 with SMTP id 6a1803df08f44-7070051b347mr106591216d6.14.1753392447547;
        Thu, 24 Jul 2025 14:27:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7070faec0b9sm18388806d6.5.2025.07.24.14.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 14:27:26 -0700 (PDT)
Message-ID: <136af381-5c31-49dd-98fe-1703a2cd57df@broadcom.com>
Date: Thu, 24 Jul 2025 14:27:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] MAINTAINERS: Include dmesg.py under PRINTK entry
To: John Ogness <john.ogness@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham
 <kbingham@kernel.org>, Michael Turquette <mturquette@baylibre.com>,
 Stephen Boyd <sboyd@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
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
 <20250625231053.1134589-13-florian.fainelli@broadcom.com>
 <84v7oic2qx.fsf@jogness.linutronix.de>
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
In-Reply-To: <84v7oic2qx.fsf@jogness.linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CCB76180004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: z5hngmqj7e34fwz4o195g69899oe9nbr
X-HE-Tag: 1753392448-563680
X-HE-Meta: U2FsdGVkX1/Rn78nyUudnfEcsm3NF/rFo14dmDOO2NmpJZvm9v78OWF4k7F2QyExJSfSIDf9qAEEXhZlK0HcP0lkeRo5e68A29mq6OYvhWWlPF4IOuwo7rNjTskkIwYPztye1wN1zn7NP8RG9Dj6E8gFAlgTZ0yL0vtG3RwUEui0dz6vpt+bcdcA4UKwz49LV0S6ixbqQ70XlkhpIBPcGh0PYzF2Co/WvgkkHeGDrxZM5dYxGarg+wmVphwK0tPHku1UR5zrLmRSJYztfPIIPGIIXpgNaqXEA53IpCk6/7ZRkVXeiPKpcA0HKlatza1BXq9gDgtpqaRAzfohaOjWcSfYn4cA1LvX+MaNoPQ06YTW0eO5VYFRHvLqUyrf6OA27DbBQBA9GtFKyyBgGf27oYliuFb/ab5+oAhUo8+5KWTEkywTHCE5RNQHN40BbHTjRX8BGXMHMh3ULOQ7/HWs6k26SReOnxcnvGlQWxtibdSnqkgHqa1D7nZ3AODT6j3ZoeFeaOaRZdg8Poa+81VvMhVIMIrRdXxjAE7N0S7nom8+pEbMsZ6F4hRS6pnfNExJT9sALdlAX91T8F4ZlNbGapKGTER7opn1H7l8d7X0+IPecqooS3ZXZ1lD5z1f89/zrDSRq5vRWb/TanUDjYbj3mKloJlSp1nq+/TdMiOwMi8CpMU+7+1jZs+7vPFA/2Lbxsj70+uQdcTgWBHhgkjh1uhf3xk+rJZYs6LpE2GFzySXQMFxYQ+0wxqEAODTu5M3ynDbukkMIAeogSX4qgd5uR7aNUiSYpC3hsEs2Cyyn3ZPYEQ2i+lK1Gs7qiTkcxRQNngry5YnINLf2xVIgWDJH4i6dhNh0IlOkIK4R/6Fck7wH7Ssvu89Jq83IFkFSWMheeYP42UylesnHZsB8YCGBzVxCbUtoKI98RBGGWi8q91b7/mNJPpR6QfmOB8DgTOcZK3uYdev7L/icxO7RAn
 1kaqnMhs
 wexb832O/DdF4ET+EOKTzGpemwy93sPc2Di6AuGGm7AUFtjblH5o6Bu796+d/txymkrRIReuoFzVXkih49DVjP1HvSfBQIDEcM/Wg6rsbiLYFiJrRoGe+YQz0tQ98Omh6YaVZ4H6CSxQyLodJY6+UJzyigBaxLXdZLorgsVwVhv58UufP3HgxQGnB5LBuHDrwE92dwDWSfZRlpK8fFbRGxSfCrs0iQSCTD1nKgJE8thv0iJ1qWjgjcMkFWVzq67cUpTK2LaQg1QxFmXBCoPvKrNdZURfAUHJLizO3heVYr6YSyePFVsqYrVbyWuS+Bm8Zu4xc88WzE9/F0olyIFkOTItGx8aGznGQ6Rdw3a3fDCsO3b4JE48rS2zDI7EdHJ41BpxnSMkAbWcH7nINUPQZu0X5QlR+LgYRKoHiWEXu981r/cgm5DO/JvYzxybCSquOoSez
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/25 01:43, John Ogness wrote:
> On 2025-06-25, Florian Fainelli <florian.fainelli@broadcom.com> wrote:
>> Include the GDB scripts file under scripts/gdb/linux/dmesg.py under the
>> PRINTK subsystem since it parses internal data structures that depend
>> upon that subsystem.
>>
>> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
>> ---
>>   MAINTAINERS | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 224825ddea83..0931440c890b 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -19982,6 +19982,7 @@ S:	Maintained
>>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/printk/linux.git
>>   F:	include/linux/printk.h
>>   F:	kernel/printk/
>> +F:	scripts/gdb/linux/dmesg.py
> 
> Note that Documentation/admin-guide/kdump/gdbmacros.txt also contains a
> similar macro (dmesg). If something needs fixing in
> scripts/gdb/linux/dmesg.py, it usually needs fixing in
> Documentation/admin-guide/kdump/gdbmacros.txt as well.
> 
> So perhaps while at it, we can also add here:
> 
> F:	Documentation/admin-guide/kdump/gdbmacros.txt

Thanks, v2 coming up.
-- 
Florian

