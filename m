Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC72B606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 07:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dJV6HXOT
Received: by kanga.kvack.org (Postfix)
	id 984906B05B2; Sat, 28 Nov 2026 02:37:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935956B05B5; Sat, 28 Nov 2026 02:37:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B076B05B6; Sat, 28 Nov 2026 02:37:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7506B05B2
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:37:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC7F81405C8
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:37:34 +0000 (UTC)
X-FDA: 85483722828.18.774B6AE
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id EC84940007
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:37:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dJV6HXOT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795851453;
	b=DSLl5XkES3IabRO99VheAOykjnygkw8dkCq2qs/kDdIuyti5plmZKEDU13Nmhe1e93iI+2
	E6+CbbrKkMqmAO+MZDiRcHC+WI1/sKHUWuYnwvADL3s1RwFjSFiCvV2fNL/+sgqwJzQLJL
	SWcHVWzlXf4cmWWY8lra0Gku4mHwkFQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795851453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL+jKdd4J7vQfapOu6Q28lbNCK5lQEUpkixYLsmn0KY=;
	b=RAY7/UmCYbNcK4oxKLNHJOQLJDtUVtWYZH7yAPetjgbs5EWLOVJumRFEgbCPK3SGzjBJjR
	ZtcOQKJT9kqnX92mxL/fguv5A7bu54rrWZpehgO6qCKgfob/HhLf7vVl12205SfkmBf2mP
	5Pn6dhY/u5O6sC8nsh5Bx37OoTY2c38=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dJV6HXOT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1a3c08d6928so13121023c88.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795851451; x=1796456251; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lL+jKdd4J7vQfapOu6Q28lbNCK5lQEUpkixYLsmn0KY=;
        b=dJV6HXOTg8w9PlO2wSMGnACJsUTT1cDonxrqfU4N5fUL4VEoA/wa3eHmJfLDvPjVb6
         nzgpZM3PEvHcCs7rKVtPKCH+EFvZDRYiNLV0f+EcNl3CGIRHzBEV0AdTJNMUHBnHMRWr
         RBpRNudRknfd8BJL6eN5HkVNeCqQ28JskZiQjiaMxmdWXU04Tyz1+ttxRUIsiLon6fBO
         Wc3riCCslyZfB6dyYNbMrEVTFx5pu7cGIWNAwJZ6Yoph4HWb/ZDjwVkk9rEAJKRnK1Dq
         RkIRnPpsypPVKUYKpudt4uASGUw+3r69blMcILagRRkkkWBzbj8czqzwh1EmqWyL72nY
         J+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795851451; x=1796456251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lL+jKdd4J7vQfapOu6Q28lbNCK5lQEUpkixYLsmn0KY=;
        b=kTSihcz+r+b3ud8VBTqRXVG7YHe7iUosIJZ75wbsVOT5T3OTACKLYaybAJMeQqNxIi
         ijUrZD+LPgrvxQAgquT0Y9oKs2dnXXhfr8TqmfoXIa07/z90NqcF+iJ3Q3+fyKQXsb0G
         dD6p8i6T6atWl+tx+iwpyaoaP8PNkmzYIy0WBO5X0VO/KjwYUJI9kcKbg6hwRXxLJMJS
         ntltz7rJpFUF6M37RSdrBzSx01Ek1OPpPKUORFI684rew00lvDLDmt0lfpUwDkNGzvKb
         b5xcSZoKJJJoF1xyETrk14p32Qc7JEt8cyc/epGAlknWdhAj1bwrq/F+HlBUY6GZ47Mv
         5rHA==
X-Gm-Message-State: APuU4Z+3Kn88PWyhmX9QznKHRAjoqAz5pNuaygs5GzX8D4jZ31M0PzxJ
	QxKFR3rXwqP17ffbG5oTfQW0bDIMQL5aoJk3eYyJwq+9ugBxuAI22jNl
X-Gm-Gg: AZFdTZdYzwJ+kjQD+0afxmaj81QX1V0DYEhaciMOPzNWKCyQjBqTPQgt9Va7rvMjGWT
	24xeUx+E8VlHx9yAFdfeZuU3/1dwGMj2MOcyPECYo09XDihP1ubwbd4NNoiUWj3IJH3X8JBkI+u
	ZqyuDfMAgCzIOt5YPCqeKE6FcMGrG4I+dliZNTuJXbnqyVq9IRBtn4m5JitYbKWO31dkaPuYkqv
	JptqEIGHj7Xvms40YwpMYFTu49XvO0yyTq+0giX3xxSStCtMRH/xeLfBlNBn/xDsCiz8+JWsiJ/
	SppUia8c6/xDw+J8AW9119P0H+NNbFAgWa95WVhZlxe/ZU8Q/U/vid3EXKxTnZqrAJ+C6XDBZ9a
	Rwv+h8aKtWfBUmKCcJaIB3PUHaeO3rNlh/LhmAr6Ryq3O1AaXlJW3ke/nVipubBRsQE0VuPxrZ8
	9nf+8fCrtPo300PdJJT78DjjcDbpHqLF2BXYv6+PGOZqcgMdN6Y5SU6mKJajquAsZT2bwT8MrPh
	8tMTWuJnqSt14hjU4L5dz2N8FiqvjWcpr61BlpCBW6Amao5/ou2bEvx5gYOopsXEaGyLX58xgQb
	XFopntbCCCz3SDI6K6qVr+y5KQXDAWpMgG+6eO2izPLEVqPx8eJ47/uzWcV0NcxvIBgx
X-Received: by 2002:a05:7022:23aa:b0:1b5:23e7:3387 with SMTP id a92af1059eb24-1b55688dd29mr36586570c88.19.1795851451449;
        Fri, 27 Nov 2026 23:37:31 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5569bffd2sm58146062c88.0.2026.11.27.23.37.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 27 Nov 2026 23:37:31 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 04/19] mm/swap: introduce swap device iteration helper
Date: Sat, 28 Nov 2026 15:36:45 +0800
Message-ID: <20261128073709.33602-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CACePvbU2cg1EVBjONWjYcsanDM0JS4eLXgX9aGYeEaXu4zZ2-w@mail.gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com> <be6ef058f4a6babd3562270daa5b61c4ff9a6a50.1795439990.git.lianux.mm@gmail.com> <CACePvbU2cg1EVBjONWjYcsanDM0JS4eLXgX9aGYeEaXu4zZ2-w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC84940007
X-Stat-Signature: ajaj11pse7t9d7jhztjecs364txza17o
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795851452-114513
X-HE-Meta: U2FsdGVkX1/eWwlq4EVIrOxYb1B9jqOUk1TKnW8yQuLSZtYiWOpyeXOBwTME0/SxyJ/J/9f4Cxj1f3gvmSHAgCl593ckiS1llENUwshNY3q/0oiV9pJYMIVrmT2TfRhf/43m9WG4hfNvTtLR2Tszjd2FyvplzKlvhhODiKYN68pPpRCtrx3fnCkY8ikb42NXdQ3pb520ah+eCVISYv4oeIRCPq3FYvwpEWYUDU+aQxnI2dk9/t0zpDm/LTnZRQVQogqsJX3YRQ27EUNXKBS4AwO8PZ1ZqSdVtEcela6XkDdcG0XfLXSGS8ZiPTEw9cF69o+Fl5W9bNSgbnFJ2+ReDZTfQRjp+BzwYONl1/5X9l9gbxX+t7jLZHdngI6dLkZk5Bl1fDVMOlBizotdcXfaB0X4auYkmCU6T5Ul+xa3tu3RM9HV4XDRoulDEeXcNZvacjHzIylorUsV3HfdirY8OmaxeCDiGf7mItkzgRLQPbgY+paNtioe8PpcWaP5/DRI5WeK5O6ns5QTtQFeu2vvx5MoIcN5udUMXrTNEsdWhRwl+X8SIwqO5U7++gdOwTpm8VR2UpCSw1sVAHwAcUbN0VISoYhIq1gtPWHWQaGBwiFX2T5xt3j4WfvVZhIhuujQyfsguz3YwAse0qNOJEGNkdpiJy4E4ZEABotorVRaTl/ByOyr1RgvOa66zBcNicD85RnrVoJXwK9sY05Zwz1p62gbBD0Uqy7MezngptEyJ69XOmLyO12lqs4mtTA8m3jkgrfUV4yy/8rhE9sAZefqC/L+lyzPORboC0hjpbrl2JI/t0ExKPaDzW3oFhWhMwYf7Qdd9Cxfhzq9GeI/gysDPccHEirDz18vqcfwMrf+SU/vranUS5xNPKfqy9Ixfn30BJh4nCcQploifCtjsKonly2rU1LEBxBC636rgN7Z9fIPhlGZVKZ1d8ligf2MU4hoc4OAwAvrgZRpy3Qxkg8
 b5VTgwHA
 CM6zaxyeH5eKLKgRoQOTqytz0WbHHuvPUIt4WVMiQ772tBjX82maozGo2Hc0NbFs/f7zNmqkcngEagLlqSXTJ3mUgQxiMunrOpU5TKmyCHMMMnP6MSZbKXgBHVU0UvpQHDICGZjZ7XkWBhCP95auvQ2k3D+Vz9+uxtJuFPRD6zm2vSMX4XVQvZal/Zux8Vn5CgrlUx3n0NdI29+uzjTnA06QisRODPeFwffmYIp1WJMzO6RkneEa5Dhb2rko0cuRttUMNS2ggFl3erWEoFCh0HOv6Z4Bpvc3Nw7i9CzbqypBFTN+vRvxnb/czJ9LnmvkGB/Y5hZS/Uu3mXl+ESOcyGiecL55yhM2EwCmCI3E9E4R+6vwofIfwHV7nAdTlFyNhEiUT+kk2nXXT5JqiVPdHwi+hkPOHCB3lQ+FPoo9CLjKLj5X9Mnf5wHsR42InAFv+reB50IlKQJQkIE/5fUM1bW64WLQr8wtBjT5xA0T6hv4VeS2xUB1DfeJQlLaXp8o5Q65Xshc+qWbNt9Y9iEfnXOkMjURBz1MBITWYA3+XgOmmq/xTZn4kwBkcYNx8FiBYZ0TgVOBMBTln8afKEm6YwK/VmG/q0BVjNO7jLH5XTDXciyV8g2RKseDdD/ysxjESZYfRObJFGiWyAJwbDVhH8JQiFrHYNN195PJJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 09:26:29 -0800 Chris Li <chrisl@kernel.org> wrote:

> Nitpick: Suggest have a internal version of "int _i", then sync to
> "int *i" at function exit.

Thanks for the ack. The macro passes its own local index, but I agree
a local int in __swap_iter() makes it clear that the bounds check and
the lookup use the same value. I'll write back the next index on exit.
I'd keep it an int for now; this iterator has no other state to carry.

> You don't need this WARN ON. When i < nr_swapfile, the swap_info[i]
> array can never the NULL. If you are paranoid you can continue if "si"
> is NULL.

Agreed. The pointer is published before nr_swapfiles is incremented,
and the descriptor is kept for reuse. I'll drop the warning and use
the _dev names you suggested, with a comment that the unfiltered form
also visits unused descriptors.

> I think for_each_swap_info() requested flags as SWP_USED |
> SWP_WRITEOK. Is this intent here to catch the race that SWP_WRITEOK
> get dropped after the for_each_swap_info()?

No. It's for_each_avail_swap() that passes SWP_USED | SWP_WRITEOK.
for_each_swap_info() passes zero, so the flag check in __swap_iter()
short-circuits without reading si->flags. In si_swapinfo() the
READ_ONCE() in the loop body is the only flags load. It counts usage
on a device that is still marked used but is no longer writable; it
doesn't depend on observing a change between two reads.

Thanks,
Lian

