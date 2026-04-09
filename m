Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC952F31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15286B0005; Thu,  9 Apr 2026 10:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CECF76B0089; Thu,  9 Apr 2026 10:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C299E6B008C; Thu,  9 Apr 2026 10:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B33A06B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:47:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A4E1C1B77
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:47:31 +0000 (UTC)
X-FDA: 84639295902.22.45DF056
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8D6F814000B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:47:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775746049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pRINhq5iI3MQOCyDCP6R2iqr+zOolqgrRedhtgh4KOA=;
	b=vYhXQ764vTB8h30vqGdM9RWrPDaN0GjEYTeqn44LgKWSL5DqY/whbcKg+FpnfIwTaj73Bq
	uvEWFeH3Pg3jOaEnJcEqpE2wLcdV4iDtN81+KVYwO3tciAKp4SemPVzQ4FxMqZImI73EYi
	f+Kkce4pE1FBC575ZO53oB1sOx/HgBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775746049; a=rsa-sha256;
	cv=none;
	b=nm0nhUI1OCkogZ015UYYGpeSPX11cAJXSE6/7Tkk+xGQlFMUjQFcgqoOmE6ffvtcBCD2b1
	6pNnFRvZRVaipqULCoOCzYz1//bk9dMOxg5Ctbl6QCzuSCOiRNQBidENT7OWvl8FNlDVU1
	OJpGykujMmiP3tpOWXxcPjL37yNB0J4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9774F592E0;
	Thu,  9 Apr 2026 14:47:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id 6EA746000A;
	Thu,  9 Apr 2026 14:47:26 +0000 (UTC)
Message-ID: <1c7e8c605d2373c26b08d0eb64cc56efd69dbc26.camel@perches.com>
Subject: Re: [linux-next:master 8662/12838] htmldocs: MAINTAINERS:40:
 WARNING: Inline strong start-string without end-string. [docutils]
From: Joe Perches <joe@perches.com>
To: Matteo Croce <technoboy85@gmail.com>, kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton
 <akpm@linux-foundation.org>,  Linux Memory Management List	
 <linux-mm@kvack.org>
Date: Thu, 09 Apr 2026 07:47:25 -0700
In-Reply-To: <CAFnufp29D4VdTgoJ4uDk-dQ4-RuO_C6=TQ7O9TA5M=JSe1j+cw@mail.gmail.com>
References: <202604090741.1kUVXMoc-lkp@intel.com>
	 <CAFnufp29D4VdTgoJ4uDk-dQ4-RuO_C6=TQ7O9TA5M=JSe1j+cw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18uJVuv+UXJvy6vOUymKWsgA5Mo2qrk7Bo=
X-HE-Meta: U2FsdGVkX18/i7UnpokYUBXsVUJRz7TSfKAldsJT9+3BICcpfdufH+GXzgkqHIDoQFes94tQKR/rxN95CWP+39VdRWdnG8Z5PqHGmUOm/PoPvMAGqA6yPVra6/qw2y5onWJgFx1d2I0XalNIqKWs76EyntueIFJYL44o4omv2NSAr72wA5F2iMaszmSYzejqIhixC6BYvCarLTOXgSr1zE+mRuh3aCaQMQkxcWt1m/Q68is1QH+DBl0Di6aRSvTvLJjnQViZv4uzSBeGyAv+Asor8gbl1mPQQwtXt3HTLfpOgX1ss2qha5w9NxnRVc5w
X-Rspamd-Queue-Id: 8D6F814000B
X-Stat-Signature: 5dbebmi6d33bdepkadcfsbnrtcqkeh4z
X-Rspam-User: 
X-HE-Tag-Orig: 1775746046-745085
X-Rspamd-Server: rspam02
X-HE-Tag: 1775746049-491382
X-HE-Meta: U2FsdGVkX1+BAH0It+nG5mkfpAl6xe3W7xQb2AH18t78MxpLn8ho6rZ1/BSa90NG9OyfAUFU8OiUc7OTtTj61urdeQhLNIq6N1jj+RVTD3euqL17aY8e3fuyZKVPxpIk0rMCjwkRcva20/2dViW+GTjqJkFeL2fP3xwZM+AStg60kj+itDhqN1Ml7euvWre/ad/Sy/lh9qDkPrxVb9yebQKDu4jAk/2sq5onL6JYA8MiRrAnhPyvdGNXGDzwjMGGpCKoR0E0jF1rCD056KyLldmBFF3S0k/9/V9qTdqjqX0K99wjStSk5isc3M1GFtkkGMKk2h7BgKMLgEc+D3QJHfcx5y5W87t+cYzpZJSPu+I3xCndhIcZH70knGH0WY6aR3rSecq3Xtc5++ptccBX/GgvEh9SaT6d5/qeP/SzClLE2ygvYwjoks6kgdoqHu/l+SiKzk8oGcIVLi2l/0kltFPQPzRmOu6ipbRHswluPiu1261zwJWlFYraMHhACNXVBbpGMIJIMKiUEwrF9KDSgx6vONsUgpdo0r+dwk3HaVhFkwDKObd8NXjYV2vPt26PwderppHsyfieL5x6eCtPO6IaI54GCsbkjaBzOWY4TY5XNobG9pHANNMI6rn8wGrt27G87H9MM2kPieOCv98Cev3UVsubawqyTvNv/at7ibDuFWZ9eFaEi84eljVnLcz3mlXOXld8FnCecgF/dwUvIDmvoOycUWVQl+NrujZlQfLpXusntovl/CLZe8IRui4TZuQMyZDk4pe7h95lFhBlnq2suWMCOSNqprcH/hLKUMREKnCReD9kfzBRleT0sRThENHaC9RiG+nXRO+zeZrEqBZBGIKwbDGNaex2FHvDEU5hA+jXgnJ8e/mwpGZc8WAf/YwKtfT4F1/JEIQ/s0krbNDNSN9jgEFWE57+uyhZhDitaQf1LY+n2w30tuRQGFuL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-04-09 at 12:12 +0200, Matteo Croce wrote:
> > > > MAINTAINERS:40: WARNING: Inline strong start-string without end-str=
ing. [docutils]
>=20
> >=20
> >    Documentation/userspace-api/landlock:480: ./security/landlock/errata=
/abi-4.h:5: ERROR: Unexpected section title.
> >=20
> >=20
>=20
>=20
> The problem is that "**" is seen as start of a bold text in RST.
> Escaping the first * fixes error and keeps the glob unaffected:
>=20
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -35,7 +35,7 @@ Descriptions of section entries and preferred order
>      F: drivers/net/ all files in and below drivers/net
>      F: drivers/net/* all files in drivers/net, but not below
>      F: */net/* all files in "any top level directory"/net
> -    F: fs/**/*foo*.c all *foo*.c files in any subdirectory of fs
> +    F: fs/\**/*foo*.c all *foo*.c files in any subdirectory of fs
>      One pattern per line.  Multiple F: lines acceptable.
>   X: *Excluded* files and directories that are NOT maintained, same
>      rules as F:. Files exclusions are tested before file matches.
>=20
> should I create a fix patch or we can still amend the previous in net-nex=
t?

nack.

this shouldn't be fixed this way.
betterwould be to not try to format things that shouldn't be formatted.

